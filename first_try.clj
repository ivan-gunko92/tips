(ns first-try)

(def 
  :^task-input 
  base-case-send-http
  :task{
        ;; what plugin to use
        :type :task.type/http-client
        :params :task.params.http-client{
                                         :method :post
                                         :headers-filler :task.vals.http-client/curl-like
                                         :headers :task.vals.http-client{"Authorization" (str "bearer: " :task.in/token)}
                                         :uri ""
                                         :uri-qs {}
                                         :content-filler :task.vals.http-client/json
                                         [:uri-qs "q"] (get :task.run/args :task.in/token "default")
                                         [:uri-qs "qs"] (-> :task.run/stdin :task.fn/read-line :task.fn/read-line )
                                         :body {:request :task.in/body
                                                :meta :task.run/time-current-ms
                                                :server-info (:task.run/file-as-in "/var/log/ice")
                                                }
                                         }
        })
