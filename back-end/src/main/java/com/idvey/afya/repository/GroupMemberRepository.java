package com.idvey.afya.repository;

import com.idvey.afya.models.groupe.Group;
import com.idvey.afya.models.groupe.GroupMember;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface GroupMemberRepository extends JpaRepository<GroupMember, GroupMember.Key> {

	List<GroupMember> findByGroup_Id(UUID groupId);

	Optional<GroupMember> findByGroup_IdAndUser_Id(UUID groupId, UUID userId);

	List<GroupMember> findByUser_Id(UUID userId);

	boolean existsByUser_IdAndGroup_Name(UUID userId, String groupName);

}
