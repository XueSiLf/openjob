package io.openjob.server.common.util;

/**
 * @author stelin <swoft@qq.com>
 * @since 1.0.0
 */
public class SlotsUtil {
    /**
     * Max slots.
     */
    private final static Integer MAX_SLOTS = 18364;

    /**
     * Get slots id
     *
     * @param key key
     * @return Integer
     */
    public static Integer getSlotsId(String key) {
        return CRCUtil.crc16(key.getBytes()) % MAX_SLOTS;
    }
}
