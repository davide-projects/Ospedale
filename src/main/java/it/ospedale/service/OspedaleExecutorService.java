package it.ospedale.service;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class OspedaleExecutorService {

    private static final OspedaleExecutorService INSTANCE = new OspedaleExecutorService();

    private final ExecutorService pool;

    private OspedaleExecutorService() {
        this.pool = Executors.newFixedThreadPool(3);
    }

    public static OspedaleExecutorService getInstance() {
        return INSTANCE;
    }

    public ExecutorService getPool() {
        return pool;
    }
}
