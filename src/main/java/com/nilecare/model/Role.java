package com.nilecare.model;

import lombok.Data;
import javax.persistence.*;

@Entity
@Table(name = "roles")
@Data // Lombok generates Getters/Setters automatically
public class Role {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "role_id")
    private Integer roleId;

    @Enumerated(EnumType.STRING)
    @Column(name = "name", unique = true, nullable = false)
    private RoleType name;

    public enum RoleType {
        ROLE_STUDENT,
        ROLE_COUNSELOR,
        ROLE_ADMIN
    }
}