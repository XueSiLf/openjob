package io.openjob.server.repository.dto;

import lombok.Data;

/**
 * @author stelin <swoft@qq.com>
 * @since 1.0.0
 */
@Data
public class DelayInstanceAddRequestDTO {

    /**
     * Delay task unique id.
     * If is null or blank, will to auto generate.
     */
    private String taskId;

    /**
     * Topic
     */
    private String topic;

    /**
     * Delay task params.
     */
    private String params;

    /**
     * Delay task extra params.
     */
    private String extra;

    /**
     * Delay task execute time.
     */
    private Integer executeTime;
}
