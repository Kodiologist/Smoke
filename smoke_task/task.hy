(require
  hyrule [pun])
(import
  thoughtforms
  thoughtforms.task [FREE-RESPONSE]
  thoughtforms.html [E RawHTML]
  metadict [MetaDict])
(setv  T True  F False)

;; * Task definition

(setv vices (dict
  :caffeine "caffeine (from drinks, like coffee or tea, or other sources)"
  :nicotine "smoking or vaping (or other tobacco or nicotine products)"
  :alcohol "alcohol"
  :cannabis "cannabis (marijuana) or products made from it"
  :harddrugs "hard drugs, such as painkillers or cocaine"
  :gambling "gambling (including lotteries or sports betting)"
  :sex "sexual behavior"
  :food "overeating"
  :computer "Internet or computer use (like social media or video games)"
  :shopping "buying or collecting things"))

(defn quit-difficulty [person]
  {
    1 f"Very easy for {person} to quit"
    2 f"Easy for {person} to quit"
    3 f"Intermediate difficulty for {person} to quit"
    4 f"Hard for {person} to quit"
    5 f"Very hard for {person} to quit"})

(defn task-callback [task page]

  (.consent-form task)

  (defn subtask [prefix intro prompt options]
    (page 'continue f"{prefix}_intro"
      (E.p intro))
    (for [[vice desc] (.items vices)]
      (page 'choice f"{prefix}_{vice}"
        [(E.p prompt) (E.p :class "vice" desc)]
        options)))

  (subtask
    "hookedon"
    "I'm going to list a few things which people might find addictive, or have a bad habit about. For each thing, tell me whether you currently have a problem of this sort."
    "Do you overindulge in this?"
    (dict
      :Yes "I indulge in this too much"
      :No "I only indulge in this in moderation, or I avoid it entirely"))

  (subtask
    "difficulty_self"
    "Now for each of the same things, imagine you indulged in it a lot, and you wanted to cut back or quit. How hard do you think it would be to quit? Give me your best guess."
    "Suppose you overindulged in this thing, and you wanted to quit. How hard do you think it would be?"
    (quit-difficulty "me"))

  (subtask
    "difficulty_other"
    "Now for some similar questions, but instead of thinking about yourself, imagine a random other user of Prolific who's taking this survey. How hard would it be for this person to quit?"
    "Suppose another person overindulged in this thing, and they wanted to quit. How hard do you think it would be?"
    (quit-difficulty "them"))

  ; Get the first vice with the greatest self-optimism.
  (setv top (max :key :optimism
    (lfor
      vice vices
      :setv me (.dval task f"difficulty_self_{vice}")
      :setv them (.dval task f"difficulty_other_{vice}")
      (pun (MetaDict :!vice :!me :!them :optimism (- them me))))))
  (.setd task "optimistic-vice" top.vice)
  (when (> top.optimism 0)
    (page 'textbox "optimism-reason" [
      (E.p :class "vice" (get vices top.vice))
      (E.p f"You said that the above thing would be {(hy.repr (get (quit-difficulty "me") top.me))} but {(hy.repr (get (quit-difficulty "them") top.them))}. Briefly, why do you think it would be easier for you to quit this thing than for the random other person?")]))

  (page 'textbox "comments"
     (E.p
       (E.em "(Optional) ")
       "Comments on this study")
     :optional T)

  (.complete task))

;; * CSS

(setv html-head "<style>
    .vice
       {font-size: 150%;
        margin-left: 2em}
    h2
       {margin-top: 2em}
    </style>")

;; * Main

(defn application [db-path]
  (thoughtforms.wsgi-application
    task-callback
    :sensitive T
    :db-path db-path
    :task-version GIT-COMMIT
    :page-title "Task"
    :language "en-US"
    :page-head (RawHTML html-head)
    :cookie-path "/"
    :consent-elements (RawHTML (.read-text
      (/ (. (hy.I.pathlib.Path __file__) parent) "consent")))))
