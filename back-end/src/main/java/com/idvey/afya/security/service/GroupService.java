package com.idvey.afya.security.service;

import com.idvey.afya.models.User;
import com.idvey.afya.models.groupe.Group;
import com.idvey.afya.models.groupe.GroupMember;
import com.idvey.afya.models.groupe.GroupRole;
import com.idvey.afya.payload.response.GroupResponse;
import com.idvey.afya.repository.GroupMemberRepository;
import com.idvey.afya.repository.GroupRepository;
import com.idvey.afya.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.security.access.AccessDeniedException;

import java.util.Comparator;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class GroupService {

	@Autowired
	private GroupRepository groupRepo;

	@Autowired
	private GroupMemberRepository memberRepo;

	@Autowired
	private UserRepository userRepo;

	@Transactional
	public UUID createGroup(UUID creatorId, String name) {
		System.out.println("[Service] createGroup called by user " + creatorId + " with name '" + name + "'");
		if (memberRepo.existsByUser_IdAndGroup_Name(creatorId, name)) {
			System.out.println("[Service] Duplicate group name detected for user " + creatorId + ": '" + name + "'");
			throw new IllegalStateException("You already have a group named '" + name + "'");
		}

		User creator = userRepo.findById(creatorId).orElseThrow(() -> new NoSuchElementException("User not found"));

		Group group = Group.builder().name(name).build();
		group = groupRepo.save(group);

		GroupMember.Key key = new GroupMember.Key();
		key.setGroupId(group.getId());
		key.setUserId(creatorId);

		GroupMember gm = GroupMember.builder().id(key).group(group).user(creator).role(GroupRole.MANAGER).build();
		memberRepo.save(gm);

		System.out.println("[Service] Group created with id " + group.getId() + " by user " + creatorId);
		return group.getId();
	}

	@Transactional
	public List<GroupMember> getMembers(UUID groupId) {
		System.out.println("[Service] getMembers called for group " + groupId);
		List<GroupMember> members = memberRepo.findByGroup_Id(groupId);
		System.out.println("[Service] Retrieved " + members.size() + " members for group " + groupId);
		return members;
	}

	@Transactional
	public void addUserToGroup(UUID groupId, UUID actorId, String usernameToAdd) {
		System.out.println("[Service] addUserToGroup called by user " + actorId + " to add '" + usernameToAdd
				+ "' to group " + groupId);
		GroupMember actor = memberRepo.findByGroup_IdAndUser_Id(groupId, actorId)
			.orElseThrow(() -> new NoSuchElementException("You are not a member of this group"));
		if (actor.getRole() != GroupRole.MANAGER) {
			System.out.println("[Service] Access denied: user " + actorId + " is not manager for group " + groupId);
			throw new AccessDeniedException("Only the manager can add members");
		}

		var newUser = userRepo.findByUsername(usernameToAdd)
			.orElseThrow(() -> new NoSuchElementException("User '" + usernameToAdd + "' not found"));

		GroupMember.Key key = new GroupMember.Key();
		key.setGroupId(groupId);
		key.setUserId(newUser.getId());
		if (memberRepo.existsById(key)) {
			System.out.println("[Service] User '" + usernameToAdd + "' is already in group " + groupId);
			throw new IllegalStateException("User is already in the group");
		}

		Group group = groupRepo.findById(groupId).orElseThrow(() -> new NoSuchElementException("Group not found"));
		GroupMember gm = GroupMember.builder().id(key).group(group).user(newUser).role(GroupRole.MEMBER).build();
		memberRepo.save(gm);

		System.out.println("[Service] User '" + usernameToAdd + "' added to group " + groupId);
	}

	@Transactional
	public void removeUserFromGroup(UUID groupId, UUID actorId, UUID targetId) {
		System.out.println("[Service] removeUserFromGroup called by user " + actorId + " to remove user " + targetId
				+ " from group " + groupId);
		GroupMember actor = memberRepo.findByGroup_IdAndUser_Id(groupId, actorId)
			.orElseThrow(() -> new NoSuchElementException("You are not a member of this group"));
		if (actor.getRole() != GroupRole.MANAGER) {
			System.out.println("[Service] Access denied: user " + actorId + " is not manager for group " + groupId);
			throw new AccessDeniedException("Only the manager can remove members");
		}
		GroupMember target = memberRepo.findByGroup_IdAndUser_Id(groupId, targetId)
			.orElseThrow(() -> new NoSuchElementException("Target user is not a member"));

		memberRepo.delete(target);
		System.out.println("[Service] User " + targetId + " removed from group " + groupId);
	}

	@Transactional
	public void renameGroup(UUID groupId, UUID actorId, String newName) {
		System.out.println("[Service] renameGroup called by user " + actorId + " for group " + groupId + " to name '"
				+ newName + "'");
		GroupMember actor = memberRepo.findByGroup_IdAndUser_Id(groupId, actorId)
			.orElseThrow(() -> new NoSuchElementException("You are not a member of this group"));
		if (actor.getRole() != GroupRole.MANAGER) {
			System.out.println("[Service] Access denied: user " + actorId + " is not manager for group " + groupId);
			throw new AccessDeniedException("Only the manager can rename the group");
		}

		if (memberRepo.existsByUser_IdAndGroup_Name(actorId, newName) && !actor.getGroup().getName().equals(newName)) {
			System.out.println("[Service] Duplicate group name on rename for user " + actorId + ": '" + newName + "'");
			throw new IllegalStateException("You already have a group named '" + newName + "'");
		}

		Group group = groupRepo.findById(groupId).orElseThrow(() -> new NoSuchElementException("Group not found"));
		group.setName(newName);
		groupRepo.save(group);
		System.out.println("[Service] Group " + groupId + " renamed to '" + newName + "'");
	}

	@Transactional
	public void leaveGroup(UUID groupId, UUID userId) {
		System.out.println("[Service] leaveGroup called by user " + userId + " for group " + groupId);
		GroupMember self = memberRepo.findByGroup_IdAndUser_Id(groupId, userId)
			.orElseThrow(() -> new NoSuchElementException("You are not a member of this group"));
		boolean wasManager = self.getRole() == GroupRole.MANAGER;
		memberRepo.delete(self);
		System.out.println("[Service] User " + userId + " left group " + groupId);

		if (!wasManager)
			return;

		var remaining = memberRepo.findByGroup_Id(groupId);
		if (remaining.isEmpty()) {
			groupRepo.deleteById(groupId);
			System.out.println("[Service] Group " + groupId + " deleted (no members left)");
			return;
		}

		var firstJoined = remaining.stream().min(Comparator.comparing(GroupMember::getJoinedAt)).orElseThrow();
		firstJoined.setRole(GroupRole.MANAGER);
		memberRepo.save(firstJoined);
		System.out
			.println("[Service] User " + firstJoined.getUser().getId() + " promoted to MANAGER for group " + groupId);
	}

	@Transactional
	public List<GroupResponse> getUserGroups(UUID userId) {
		System.out.println("[Service] getUserGroups called for user " + userId);
		var memberships = memberRepo.findByUser_Id(userId);
		var responses = memberships.stream()
			.map(m -> new GroupResponse(m.getGroup().getId(), m.getGroup().getName(), m.getRole()))
			.collect(Collectors.toList());
		System.out.println("[Service] User " + userId + " belongs to " + responses.size() + " groups");
		return responses;
	}

}