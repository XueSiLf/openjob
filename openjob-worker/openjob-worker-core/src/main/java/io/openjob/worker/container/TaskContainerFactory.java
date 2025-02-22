package io.openjob.worker.container;

import io.openjob.worker.request.MasterStartContainerRequest;
import org.apache.commons.lang3.StringUtils;

import java.lang.reflect.Constructor;

/**
 * @author stelin <swoft@qq.com>
 * @see ThreadTaskContainer
 * @since 1.0.0
 */
public class TaskContainerFactory {

    /**
     * Create task container.
     *
     * @param startRequest start request.
     * @return TaskContainer
     */
    public static TaskContainer create(MasterStartContainerRequest startRequest) {
        String containerType = "thread";

        try {
            String className = String.format("io.openjob.worker.container.%sTaskContainer", StringUtils.capitalize(containerType));
            @SuppressWarnings("unchecked")
            Constructor<? extends TaskContainer> constructor = ((Class<? extends TaskContainer>) Class.forName(className))
                    .getConstructor(MasterStartContainerRequest.class);
            return constructor.newInstance(startRequest);
        } catch (Throwable ex) {
            throw new RuntimeException("Task master is not exist! executeType=" + containerType);
        }
    }
}
