package io.openjob.server.admin.request;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.constraints.NotBlank;

/**
 * @author stelin <swoft@qq.com>
 * @since 1.0.0
 */
@Data
@ApiModel
public class AddNamespaceRequest {

    @NotBlank
    @ApiModelProperty(value = "Namespace name", required = true)
    private String name;

    @ApiModelProperty(value = "Namespace desc", required = true)
    private String desc;

    @ApiModelProperty(value = "Namespace visit secret, use md5 submit", required = true)
    private String secret;
}
