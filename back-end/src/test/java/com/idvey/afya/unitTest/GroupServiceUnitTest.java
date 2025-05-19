package com.idvey.afya.unitTest;

import com.idvey.afya.models.User;
import com.idvey.afya.models.groupe.Group;
import com.idvey.afya.models.groupe.GroupMember;
import com.idvey.afya.models.groupe.GroupMember.Key;
import com.idvey.afya.models.groupe.GroupRole;
import com.idvey.afya.payload.response.GroupResponse;
import com.idvey.afya.repository.GroupMemberRepository;
import com.idvey.afya.repository.GroupRepository;
import com.idvey.afya.repository.UserRepository;
import com.idvey.afya.security.service.GroupService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.access.AccessDeniedException;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class GroupServiceUnitTest {

	@Mock
	private GroupRepository groupRepo;

	@Mock
	private GroupMemberRepository memberRepo;

	@Mock
	private UserRepository userRepo;

	@InjectMocks
	private GroupService groupService;

	private UUID userId;

	private User user;

	@BeforeEach
	void init() {
		userId = UUID.randomUUID();
		user = new User();
		user.setId(userId);
		user.setUsername("alice");
	}

	@Test
	void createGroup_Success() {
		String name = "Group1";
		when(memberRepo.existsByUser_IdAndGroup_Name(userId, name)).thenReturn(false);
		when(userRepo.findById(userId)).thenReturn(Optional.of(user));
		UUID generatedId = UUID.randomUUID();
		when(groupRepo.save(any(Group.class))).thenAnswer(invocation -> {
			Group g = invocation.getArgument(0);
			g.setId(generatedId);
			return g;
		});

		UUID result = groupService.createGroup(userId, name);
		assertEquals(generatedId, result);

		ArgumentCaptor<GroupMember> captor = ArgumentCaptor.forClass(GroupMember.class);
		verify(memberRepo).save(captor.capture());
		GroupMember gm = captor.getValue();
		assertEquals(userId, gm.getUser().getId());
		assertEquals(generatedId, gm.getGroup().getId());
		assertEquals(GroupRole.MANAGER, gm.getRole());
	}

	@Test
	void createGroup_Duplicate_Throws() {
		String name = "Group1";
		when(memberRepo.existsByUser_IdAndGroup_Name(userId, name)).thenReturn(true);

		IllegalStateException ex = assertThrows(IllegalStateException.class,
				() -> groupService.createGroup(userId, name));
		assertTrue(ex.getMessage().contains("already have a group named"));
	}

	@Test
	void addUserToGroup_NotManager_Throws() {
		UUID groupId = UUID.randomUUID();
		GroupMember actor = new GroupMember();
		actor.setRole(GroupRole.MEMBER);
		when(memberRepo.findByGroup_IdAndUser_Id(groupId, userId)).thenReturn(Optional.of(actor));

		assertThrows(AccessDeniedException.class, () -> groupService.addUserToGroup(groupId, userId, "bob"));
	}

	@Test
	void addUserToGroup_Success() {
		UUID groupId = UUID.randomUUID();
		GroupMember actor = new GroupMember();
		actor.setRole(GroupRole.MANAGER);
		when(memberRepo.findByGroup_IdAndUser_Id(groupId, userId)).thenReturn(Optional.of(actor));
		User bob = new User();
		bob.setId(UUID.randomUUID());
		bob.setUsername("bob");
		when(userRepo.findByUsername("bob")).thenReturn(Optional.of(bob));
		Key key = new Key();
		key.setGroupId(groupId);
		key.setUserId(bob.getId());
		when(memberRepo.existsById(key)).thenReturn(false);
		Group group = new Group();
		group.setId(groupId);
		group.setName("G");
		when(groupRepo.findById(groupId)).thenReturn(Optional.of(group));

		groupService.addUserToGroup(groupId, userId, "bob");
		verify(memberRepo).save(any(GroupMember.class));
	}

	@Test
	void removeUserFromGroup_NotManager_Throws() {
		UUID groupId = UUID.randomUUID();
		UUID targetId = UUID.randomUUID();
		GroupMember actor = new GroupMember();
		actor.setRole(GroupRole.MEMBER);
		when(memberRepo.findByGroup_IdAndUser_Id(groupId, userId)).thenReturn(Optional.of(actor));

		assertThrows(AccessDeniedException.class, () -> groupService.removeUserFromGroup(groupId, userId, targetId));
	}

	@Test
	void removeUserFromGroup_Success() {
		UUID groupId = UUID.randomUUID();
		UUID targetId = UUID.randomUUID();
		GroupMember actor = new GroupMember();
		actor.setRole(GroupRole.MANAGER);
		GroupMember target = new GroupMember();
		target.setRole(GroupRole.MEMBER);
		when(memberRepo.findByGroup_IdAndUser_Id(groupId, userId)).thenReturn(Optional.of(actor));
		when(memberRepo.findByGroup_IdAndUser_Id(groupId, targetId)).thenReturn(Optional.of(target));

		groupService.removeUserFromGroup(groupId, userId, targetId);
		verify(memberRepo).delete(target);
	}

	@Test
	void getUserGroups_ReturnsList() {
		Group g1 = new Group();
		g1.setId(UUID.randomUUID());
		g1.setName("G1");
		GroupMember m1 = new GroupMember();
		m1.setGroup(g1);
		m1.setRole(GroupRole.MANAGER);
		Group g2 = new Group();
		g2.setId(UUID.randomUUID());
		g2.setName("G2");
		GroupMember m2 = new GroupMember();
		m2.setGroup(g2);
		m2.setRole(GroupRole.MEMBER);
		when(memberRepo.findByUser_Id(userId)).thenReturn(List.of(m1, m2));

		List<GroupResponse> responses = groupService.getUserGroups(userId);
		assertEquals(2, responses.size());
		assertTrue(responses.stream().anyMatch(r -> r.getName().equals("G1") && r.getRole() == GroupRole.MANAGER));
	}

}