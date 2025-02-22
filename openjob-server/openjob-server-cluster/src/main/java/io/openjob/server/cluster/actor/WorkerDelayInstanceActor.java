package io.openjob.server.cluster.actor;

import io.openjob.common.actor.BaseActor;
import io.openjob.common.request.WorkerDelayAddRequest;
import io.openjob.common.response.Result;
import io.openjob.common.response.ServerDelayAddResponse;
import io.openjob.server.scheduler.service.DelayInstanceService;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

/**
 * @author stelin <swoft@qq.com>
 * @since 1.0.0
 */
@Component
@Log4j2
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class WorkerDelayInstanceActor extends BaseActor {

    private final DelayInstanceService delayInstanceService;

    @Autowired
    public WorkerDelayInstanceActor(DelayInstanceService delayInstanceService) {
        this.delayInstanceService = delayInstanceService;
    }

    @Override
    public Receive createReceive() {
        return receiveBuilder()
                .match(WorkerDelayAddRequest.class, this::handleAdd)
                .build();
    }

    public void handleAdd(WorkerDelayAddRequest addRequest) {
        ServerDelayAddResponse serverDelayAddResponse = this.delayInstanceService.addDelayInstance(addRequest);
        getSender().tell(Result.success(serverDelayAddResponse), getSelf());
    }
}
