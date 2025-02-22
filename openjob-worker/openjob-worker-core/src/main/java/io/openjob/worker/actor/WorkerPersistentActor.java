package io.openjob.worker.actor;

import akka.actor.ActorSelection;
import akka.persistence.AbstractPersistentActorWithAtLeastOnceDelivery;
import io.openjob.common.constant.StatusEnum;
import io.openjob.common.request.WorkerJobInstanceStatusRequest;
import io.openjob.common.response.Result;
import io.openjob.common.response.ServerResponse;
import io.openjob.common.response.WorkerResponse;
import io.openjob.worker.request.ContainerBatchTaskStatusRequest;
import io.openjob.worker.util.WorkerUtil;
import lombok.extern.slf4j.Slf4j;

import java.util.Objects;

/**
 * @author stelin <swoft@qq.com>
 * @since 1.0.0
 */
@Slf4j
public class WorkerPersistentActor extends AbstractPersistentActorWithAtLeastOnceDelivery {
    private final Integer id;

    public WorkerPersistentActor(Integer id) {
        this.id = id;
    }

    @Override
    public Receive createReceiveRecover() {
        return receiveBuilder()
                .matchAny(System.out::println)
                .build();
    }

    @Override
    public Receive createReceive() {
        return receiveBuilder()
                .match(ContainerBatchTaskStatusRequest.class, this::handleBatchTaskStatus)
                .match(WorkerJobInstanceStatusRequest.class, this::handleJobInstanceStatus)
                .match(Result.class, this::handleResult)
                .build();
    }

    /**
     * Handle batch task status.
     *
     * @param batchRequest batch request.
     */
    public void handleBatchTaskStatus(ContainerBatchTaskStatusRequest batchRequest) {
        ActorSelection masterSelection = getContext().actorSelection(batchRequest.getMasterActorPath());
        deliver(masterSelection, deliveryId -> {
            batchRequest.setDeliveryId(deliveryId);
            return batchRequest;
        });
    }

    /**
     * Handle job instance status request.
     *
     * @param jobInstanceStatusReq status request.
     */
    public void handleJobInstanceStatus(WorkerJobInstanceStatusRequest jobInstanceStatusReq) {
        ActorSelection serverWorkerActor = WorkerUtil.getServerWorkerJobInstanceActor();
        deliver(serverWorkerActor, deliveryId -> {
            jobInstanceStatusReq.setDeliveryId(deliveryId);
            return jobInstanceStatusReq;
        });
    }

    /**
     * Handle result
     *
     * @param result result.
     */
    public void handleResult(Result<?> result) {
        if (StatusEnum.FAIL.getStatus().equals(result.getStatus()) || Objects.isNull(result.getData())) {
            log.error("Handle result fail! message={}", result.getMessage());
            return;
        }

        if (result.getData() instanceof WorkerResponse) {
            WorkerResponse workerResponse = (WorkerResponse) result.getData();
            confirmDelivery(workerResponse.getDeliveryId());
            return;
        }

        if (result.getData() instanceof ServerResponse) {
            ServerResponse serverResponse = (ServerResponse) result.getData();
            confirmDelivery(serverResponse.getDeliveryId());
            return;
        }

        log.error("Handle result data not defined data={}", result.getData().toString());
    }

    @Override
    public String persistenceId() {
        return String.format("persistence-new-id-%d", id);
    }
}
