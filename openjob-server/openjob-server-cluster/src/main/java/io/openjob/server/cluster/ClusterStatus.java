package io.openjob.server.cluster;

import akka.actor.ActorRef;
import com.google.common.collect.Maps;
import io.openjob.server.cluster.context.Node;
import io.openjob.server.cluster.context.Slots;
import lombok.extern.log4j.Log4j2;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author stelin <swoft@qq.com>
 * @since 1.0.0
 */
@Log4j2
public class ClusterStatus {

    /**
     * Cluster actor reference.
     */
    private static ActorRef clusterActorRef;

    /**
     * Current node.
     */
    private static Node currentNode;

    /**
     * Job instance slots.
     */
    private static final List<Long> currentSlots = new ArrayList<>();

    /**
     * Cluster nodes.
     */
    private static Map<Long, Node> nodesMap = Maps.newConcurrentMap();

    public static synchronized void removeSlots(List<Long> slotsIds) {
        currentSlots.removeAll(slotsIds);
    }

    public static synchronized void addSlots(List<Long> slotsIds) {
        currentSlots.addAll(slotsIds);
    }


    /**
     * Refresh nodes.
     *
     * @param nodes nodes
     */
    public static synchronized void refreshNodes(Map<Long, Node> nodes) {
        nodesMap = nodes;
    }

    /**
     * Append node.
     *
     * @param serverId serverId
     * @param node     node
     */
    public static synchronized void addNode(Long serverId, Node node) {
        nodesMap.put(serverId, node);
    }

    /**
     * Removes node.
     *
     * @param serverId serverId
     */
    public static synchronized void removeNode(Long serverId) {
        nodesMap.remove(serverId);
    }

    /**
     * Set cluster actor reference.
     *
     * @param clusterActorRef clusterActorRef
     */
    public static synchronized void setClusterActorRef(ActorRef clusterActorRef) {
        ClusterStatus.clusterActorRef = clusterActorRef;
    }

    /**
     * Set current node.
     *
     * @param currentNode currentNode
     */
    public static synchronized void setCurrentNode(Node currentNode) {
        ClusterStatus.currentNode = currentNode;
    }

    /**
     * Return nodes.
     *
     * @return Map<Long, Node>
     */
    public static Map<Long, Node> getNodesMap() {
        return nodesMap;
    }

    public static List<Long> getCurrentSlots() {
        return currentSlots;
    }

    public static ActorRef getClusterActorRef() {
        return clusterActorRef;
    }

    /**
     * Return node.
     *
     * @return Node
     */
    public static Node getCurrentNode() {
        return currentNode;
    }
}
