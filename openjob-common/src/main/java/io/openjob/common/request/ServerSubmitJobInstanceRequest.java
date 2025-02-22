package io.openjob.common.request;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * @author stelin <swoft@qq.com>
 * @since 1.0.0
 */
@Data
public class ServerSubmitJobInstanceRequest implements Serializable {
    private Long jobId;
    private Long jobInstanceId;
    private String jobParams;
    private Long workflowId;
    private String processorType;
    private String processorInfo;
    private String executeType;
    private Integer failRetryTimes;
    private Integer failRetryInterval;
    private Integer concurrency;
    private String timeExpressionType;
    private String timeExpression;
    private List<String> workerAddresses;
}
