package io.openjob.server.cluster.service;

import io.openjob.common.request.WorkerStartRequest;
import io.openjob.common.request.WorkerStopRequest;
import io.openjob.common.util.DateUtil;
import io.openjob.server.cluster.dto.WorkerFailDTO;
import io.openjob.server.cluster.dto.WorkerJoinDTO;
import io.openjob.server.cluster.util.ClusterUtil;
import io.openjob.server.repository.constant.ServerStatusEnum;
import io.openjob.server.repository.constant.WorkerStatusConstant;
import io.openjob.server.repository.dao.AppDAO;
import io.openjob.server.repository.dao.ServerDAO;
import io.openjob.server.repository.dao.WorkerDAO;
import io.openjob.server.repository.entity.App;
import io.openjob.server.repository.entity.Server;
import io.openjob.server.repository.entity.Worker;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

/**
 * @author stelin <swoft@qq.com>
 * @since 1.0.0
 */
@Service
@Log4j2
public class WorkerService {
    private final WorkerDAO workerDAO;
    private final AppDAO appDAO;
    private final ServerDAO serverDAO;

    @Autowired
    public WorkerService(WorkerDAO workerDAO, AppDAO appDAO, ServerDAO serverDAO) {
        this.workerDAO = workerDAO;
        this.appDAO = appDAO;
        this.serverDAO = serverDAO;
    }

    /**
     * Worker start
     *
     * @param workerStartRequest start request.
     */
    public void workerStart(WorkerStartRequest workerStartRequest) {
        // Update worker status.
        this.updateWorkerForStart(workerStartRequest);

        // Refresh cluster context.
        refreshClusterContext();

        // Akka message for worker start.
        List<Server> servers = serverDAO.listServers(ServerStatusEnum.OK.getStatus());
        ClusterUtil.sendMessage(new WorkerJoinDTO(), servers);
    }

    /**
     * Worker stop
     *
     * @param stopReq stop request.
     */
    public void workerStop(WorkerStopRequest stopReq) {
        int now = DateUtil.now();
        Worker worker = workerDAO.getByAddress(stopReq.getAddress());
        if (Objects.isNull(worker)) {
            log.error("worker({}) do not exist!", stopReq.getAddress());
            return;
        }

        worker.setStatus(WorkerStatusConstant.OFFLINE.getStatus());
        worker.setUpdateTime(now);

        // Refresh cluster context.
        this.refreshClusterContext();

        // Akka message for worker start.
        List<Server> servers = serverDAO.listServers(ServerStatusEnum.OK.getStatus());
        ClusterUtil.sendMessage(new WorkerFailDTO(), servers);
    }

    private void refreshClusterContext() {
        List<Worker> workers = workerDAO.listOnlineWorkers();
        ClusterUtil.refreshAppWorkers(workers);
    }

    private void updateWorkerForStart(WorkerStartRequest startReq) {
        // app
        App app = appDAO.getAppByName(startReq.getAppName());
        if (Objects.isNull(app)) {
            throw new RuntimeException(String.format("app(%s) do not exist!", startReq.getAppName()));
        }

        // Update worker.
        int now = DateUtil.now();
        Worker worker = workerDAO.getByAddress(startReq.getAddress());
        if (Objects.nonNull(worker)) {
            worker.setWorkerKey(worker.getWorkerKey());
            worker.setStatus(WorkerStatusConstant.ONLINE.getStatus());
            workerDAO.save(worker);
            return;
        }

        // save
        Worker saveWorker = new Worker();
        saveWorker.setUpdateTime(now);
        saveWorker.setCreateTime(now);
        saveWorker.setWorkerKey(startReq.getWorkerKey());
        saveWorker.setAddress(startReq.getAddress());
        saveWorker.setStatus(WorkerStatusConstant.ONLINE.getStatus());
        saveWorker.setAppId(app.getId());
        saveWorker.setAppName(startReq.getAppName());
        saveWorker.setLastHeartbeatTime(now);
        saveWorker.setNamespaceId(app.getNamespaceId());
        saveWorker.setProtocolType(startReq.getProtocolType());
        saveWorker.setVersion(startReq.getVersion());
        saveWorker.setMetric("");
        saveWorker.setVersion("");
        saveWorker.setWorkerKey("");
        workerDAO.save(saveWorker);
    }
}
