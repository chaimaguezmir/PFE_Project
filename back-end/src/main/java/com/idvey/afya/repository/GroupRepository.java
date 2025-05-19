package com.idvey.afya.repository;

import com.idvey.afya.models.groupe.Group;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface GroupRepository extends JpaRepository<Group, UUID> {

	Optional<Group> findByName(String name);

	boolean existsByName(String name);

}