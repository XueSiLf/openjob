package io.openjob.common.request;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * @author stelin <swoft@qq.com>
 * @since 1.0.0
 */
@Data
public class WorkerDelayPullRequest implements Serializable {
    private List<WorkerDelayPullItemRequest> pullItems;
}