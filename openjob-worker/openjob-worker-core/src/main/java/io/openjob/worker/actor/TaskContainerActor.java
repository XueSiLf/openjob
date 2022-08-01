package io.openjob.worker.actor;

import io.openjob.common.actor.BaseActor;
import io.openjob.common.response.Result;
import io.openjob.common.response.WorkerResponse;
import io.openjob.worker.container.TaskContainer;
import io.openjob.worker.container.TaskContainerFactory;
import io.openjob.worker.context.JobContext;
import io.openjob.worker.request.MasterBatchStartContainerRequest;
import io.openjob.worker.request.MasterDestroyContainerRequest;
import io.openjob.worker.request.MasterStartContainerRequest;
import io.openjob.worker.request.MasterStopContainerRequest;

import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * @author stelin <swoft@qq.com>
 * @since 1.0.0
 */
public class TaskContainerActor extends BaseActor {
    private static final ThreadPoolExecutor containerExecutor;

    static {
        containerExecutor = new ThreadPoolExecutor(
                2,
                2,
                30,
                TimeUnit.SECONDS,
                new LinkedBlockingQueue<>(),
                r -> new Thread(r, "Openjob-container-executor"),
                new ThreadPoolExecutor.CallerRunsPolicy()
        );
        containerExecutor.allowCoreThreadTimeOut(true);
    }

    @Override
    public Receive createReceive() {
        return receiveBuilder()
                .match(MasterStartContainerRequest.class, this::handleStartContainer)
                .match(MasterBatchStartContainerRequest.class, this::handleBatchStartContainer)
                .match(MasterStopContainerRequest.class, this::handleStopContainer)
                .match(MasterDestroyContainerRequest.class, this::handleDestroyContainer)
                .build();
    }

    public void handleStartContainer(MasterStartContainerRequest startReq) {
        this.startContainer(startReq);
        getSender().tell(Result.success(new WorkerResponse()), getSelf());
    }

    public void handleBatchStartContainer(MasterBatchStartContainerRequest batchStartReq) {
        containerExecutor.submit(new ContainerRunnable(batchStartReq));
        getSender().tell(Result.success(new WorkerResponse()), getSelf());
    }

    public void handleStopContainer(MasterStopContainerRequest stopReq) {

    }

    public void handleDestroyContainer(MasterDestroyContainerRequest destroyReq) {

    }

    private void startContainer(MasterStartContainerRequest startReq) {
        JobContext jobContext = new JobContext();
        jobContext.setJobId(startReq.getJobId());
        jobContext.setJobInstanceId(startReq.getJobInstanceId());
        jobContext.setTaskId(startReq.getTaskId());
        jobContext.setJobParams(startReq.getJobParams());
        jobContext.setProcessorType(startReq.getProcessorType());
        jobContext.setProcessorInfo(startReq.getProcessorInfo());
        jobContext.setFailRetryInterval(startReq.getFailRetryInterval());
        jobContext.setFailRetryTimes(startReq.getFailRetryTimes());
        jobContext.setExecuteType(startReq.getExecuteType());
        jobContext.setConcurrency(startReq.getConcurrency());
        jobContext.setTimeExpression(startReq.getTimeExpression());
        jobContext.setTimeExpressionType(startReq.getTimeExpressionType());
        jobContext.setWorkerAddresses(startReq.getWorkerAddresses());

        TaskContainer taskContainer = TaskContainerFactory.create(jobContext);
        TaskContainerFactory.getPool().submit(
                jobContext.getJobId(),
                jobContext.getJobInstanceId(),
                jobContext.getTaskId(),
                jobContext.getConcurrency(),
                taskContainer
        );
    }

    private class ContainerRunnable implements Runnable {
        private MasterBatchStartContainerRequest containerRequest;

        public ContainerRunnable(MasterBatchStartContainerRequest containerRequest) {
            this.containerRequest = containerRequest;
        }

        @Override
        public void run() {
            for (MasterStartContainerRequest req : this.containerRequest.getStartContainerRequests()) {
                startContainer(req);
            }
        }
    }
}
