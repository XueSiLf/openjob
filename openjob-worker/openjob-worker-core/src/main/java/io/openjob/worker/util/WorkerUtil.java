package io.openjob.worker.util;

import akka.actor.ActorSelection;
import io.openjob.common.constant.AkkaConstant;
import io.openjob.worker.OpenjobWorker;
import io.openjob.worker.config.OpenjobConfig;
import io.openjob.worker.constant.WorkerAkkaConstant;
import io.openjob.worker.constant.WorkerConstant;

/**
 * @author stelin <swoft@qq.com>
 * @since 1.0.0
 */
public class WorkerUtil {

    public static ActorSelection getServerWorkerActor() {
        String address = getServerAddress();
        return OpenjobWorker.getActorSystem().actorSelection(getServerActorPath(address, AkkaConstant.SERVER_ACTOR_WORKER));
    }

    public static ActorSelection getServerWorkerJobInstanceActor() {
        String address = getServerAddress();
        return OpenjobWorker.getActorSystem().actorSelection(getServerActorPath(address, AkkaConstant.SERVER_ACTOR_WORKER_INSTANCE));
    }

    public static ActorSelection getServerWorkerJobInstanceTaskLogActor() {
        String address = getServerAddress();
        return OpenjobWorker.getActorSystem().actorSelection(getServerActorPath(address, AkkaConstant.SERVER_ACTOR_WORKER_INSTANCE_TASK_LOG));
    }

    public static ActorSelection getServerHeartbeatActor() {
        String address = getServerAddress();
        return OpenjobWorker.getActorSystem().actorSelection(getServerActorPath(address, AkkaConstant.SERVER_ACTOR_WORKER_HEARTBEAT));
    }

    public static ActorSelection getServerDelayInstanceActor() {
        String address = getServerAddress();
        return OpenjobWorker.getActorSystem().actorSelection(getServerActorPath(address, AkkaConstant.SERVER_ACTOR_WORKER_DELAY_INSTANCE));
    }

    public static ActorSelection getServerDelayStatusActor() {
        String address = getServerAddress();
        return OpenjobWorker.getActorSystem().actorSelection(getServerActorPath(address, AkkaConstant.SERVER_ACTOR_WORKER_DELAY_STATUS));
    }

    /**
     * @param address address
     * @param name    actor name
     * @return actor path
     */
    public static String getServerActorPath(String address, String name) {
        return String.format(AkkaConstant.AKKA_PATH_FORMAT, AkkaConstant.SERVER_SYSTEM_NAME, address, name);
    }

    public static String getServerAddress() {
        return String.format("%s:%d", OpenjobConfig.getString(WorkerConstant.SERVER_HOST), OpenjobConfig.getInteger(WorkerConstant.SERVER_PORT));
    }

    public static String getWorkerMasterActorPath(String address) {
        return getWorkerActorPath(address, AkkaConstant.WORKER_PATH_TASK_MASTER);
    }

    public static String getWorkerContainerActorPath(String address) {
        return getWorkerActorPath(address, WorkerAkkaConstant.PATH_TASK_CONTAINER);
    }

    public static String getWorkerActorPath(String address, String path) {
        return String.format("akka://%s@%s%s", AkkaConstant.WORKER_SYSTEM_NAME, address, path);
    }
}
