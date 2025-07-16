package com.idvey.afya.security.service;

import com.idvey.afya.models.PharmacyBox;
import com.idvey.afya.models.User;
import com.idvey.afya.models.groupe.Group;
import com.idvey.afya.models.groupe.GroupMember;
import com.idvey.afya.models.groupe.GroupRole;
import com.idvey.afya.payload.response.PharmacyBoxResponse;
import com.idvey.afya.repository.GroupMemberRepository;
import com.idvey.afya.repository.GroupRepository;
import com.idvey.afya.repository.PharmacyBoxRepository;
import com.idvey.afya.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PharmacyBoxService {

	private final PharmacyBoxRepository pharmacyBoxRepository;

	private final GroupRepository groupRepository;

	private final GroupMemberRepository groupMemberRepository;

	private final UserRepository userRepository;

	public PharmacyBoxResponse create(UUID groupId, UUID userId) {
		User user = getUser(userId);
		Group group = getGroup(groupId);
		verifyIsManager(user.getId(), group.getId());

		if (group.getPharmacyBox() != null) {
			throw new IllegalStateException("PharmacyBox already exists for this group.");
		}

		PharmacyBox box = PharmacyBox.builder().group(group).build();

		PharmacyBox saved = pharmacyBoxRepository.save(box);
		return toResponse(saved);
	}

	@Transactional(readOnly = true)
	public List<PharmacyBoxResponse> getByUserId(UUID userId) {
		getUser(userId); // throws if user not found

		return groupMemberRepository.findByUser_IdWithGroupAndPharmacyBox(userId)
				.stream()
				.map(GroupMember::getGroup)
				.filter(group -> group.getPharmacyBox() != null)
				.map(group -> toResponse(group.getPharmacyBox()))
				.toList();
	}

	private PharmacyBoxResponse toResponse(PharmacyBox box) {
		// Ensure medications are loaded
		PharmacyBox loadedBox = pharmacyBoxRepository.findByIdWithMedications(box.getId()).orElse(box);
		int count = (loadedBox.getMyMedicines() != null) ? loadedBox.getMyMedicines().size() : 0;
		return new PharmacyBoxResponse(loadedBox.getId(), loadedBox.getGroup().getName(), count);
	}

	private void verifyIsManager(UUID userId, UUID groupId) {
		GroupMember member = groupMemberRepository.findByGroup_IdAndUser_Id(groupId, userId)
			.orElseThrow(() -> new SecurityException("You are not a member of this group."));

		if (member.getRole() != GroupRole.MANAGER) {
			throw new SecurityException("Access denied: only MANAGER can perform this action.");
		}
	}

	private User getUser(UUID userId) {
		return userRepository.findById(userId).orElseThrow(() -> new NoSuchElementException("User not found."));
	}

	private Group getGroup(UUID groupId) {
		return groupRepository.findById(groupId).orElseThrow(() -> new NoSuchElementException("Group not found."));
	}

}