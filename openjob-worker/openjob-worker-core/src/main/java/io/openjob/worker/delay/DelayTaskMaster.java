package io.openjob.worker.delay;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.LinkedBlockingDeque;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * @author stelin <swoft@qq.com>
 * @since 1.0.0
 */
public class DelayTaskMaster {
    private ExecutorService executorService;

    /**
     * Init
     */
    public void init() {
        executorService = new ThreadPoolExecutor(
                1,
                1,
                30,
                TimeUnit.SECONDS,
                new LinkedBlockingDeque<>(0),
                r -> new Thread(r, "Openjob-delay-master")
        );

        this.executorService.submit(new DelayTaskMasterExecutor());
    }

    /**
     * Stop
     */
    public void stop() {
        this.executorService.shutdown();
    }
}
