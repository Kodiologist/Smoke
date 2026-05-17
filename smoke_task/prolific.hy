(import
  thoughtforms.prolific :as P)


(defn make-study [db-path task-url]
  (P.make-study
    :db-path db-path
    :task-url task-url
    :project "6a08805bae69eebc754a5a2d"
    :name "Bad Habits"
    :internal-name "smoke"
    :description "Answer some questions about overindulgence."
    :estimated-completion-minutes 5
    :reward-cents 100
    :filters [(P.first-lang-english)]))
