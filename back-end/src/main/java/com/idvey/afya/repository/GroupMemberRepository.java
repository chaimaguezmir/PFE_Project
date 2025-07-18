package com.idvey.afya.repository;

import com.idvey.afya.models.groupe.GroupMember;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
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

	@Query("SELECT gm FROM GroupMember gm JOIN FETCH gm.user WHERE gm.group.id = :groupId")
	List<GroupMember> findAllByGroupIdWithUser(@Param("groupId") UUID groupId);

	boolean existsByUser_IdAndGroup_Id(UUID userId, UUID groupId);

	// GroupMemberRepository.java
	@Query("SELECT gm FROM GroupMember gm JOIN FETCH gm.group g LEFT JOIN FETCH g.pharmacyBox WHERE gm.user.id = :userId")
	List<GroupMember> findByUser_IdWithGroupAndPharmacyBox(@Param("userId") UUID userId);

}
