package io.openjob.common.response;

import lombok.Data;

import java.io.Serializable;

/**
 * @author stelin <swoft@qq.com>
 * @since 1.0.0
 */
@Data
public class ServerResponse implements Serializable {
    private Long deliveryId;

    public ServerResponse() {
    }

    public ServerResponse(Long deliveryId) {
        this.deliveryId = deliveryId;
    }
}
