package io.openjob.server.repository.entity;

import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * @author stelin <swoft@qq.com>
 * @since 1.0.0
 */
@Data
@Entity
@Table(name = "delay")
public class Delay {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "namespace_id")
    private Long namespaceId;

    @Column(name = "app_id")
    private Long appId;

    @Column(name = "name")
    private String name;

    @Column(name = "description")
    private String description;

    @Column(name = "processor_info")
    private String processorInfo;

    @Column(name = "fail_retry_times")
    private Integer failRetryTimes;

    @Column(name = "fail_retry_interval")
    private Integer failRetryInterval;

    @Column(name = "status")
    private Integer status;

    @Column(name = "execute_timeout")
    private Integer executeTimeout;

    @Column(name = "concurrency")
    private Integer concurrency;

    @Column(name = "topic")
    private String topic;

    @Column(name = "create_time")
    private Integer createTime;

    @Column(name = "update_time")
    private Integer updateTime;

}
