;gnu clisp 2.49

;Marc Mehrer
;Jan Luksch

(defun get-value (tree); gibt Wert im aktuellen Knoten zurück
    (cond
        ((integerp(second tree)) (second tree))
        (T nil)
    )
)

(defun get-left-subtree (tree); gibt den linken Teilbaum zurück
    (first tree)
)

(defun get-right-subtree (tree); gibt den rechten Teilbau zurück
    (third tree)
)

(defun insert (tree val); fügt val in einen neuen Baum ein und gibt ihn zurück
    (cond
        ((null tree) (list '() val '()))
        ((eql (get-value tree) val) tree)
        ((< (get-value tree) val) (append (list(get-left-subtree tree)) (list (get-value tree)) (list(insert (get-right-subtree tree) val))))
        ((> (get-value tree) val) (append (list(insert (get-left-subtree tree) val)) (list (get-value tree)) (list(get-right-subtree tree))))
    )
)

(defun contains (tree val); gibt T oder nil zurück
    (cond
        ((null (get-value tree)) nil)
        ((eql (get-value tree) val) T)
        ((< (get-value tree) val) (contains (get-right-subtree tree) val))
        ((> (get-value tree) val) (contains (get-left-subtree tree) val))
    )
)

(defun size (tree); gibt größe des (Teil)Baums zurück
    (cond
        ((null (get-value tree)) 0)
        (T (+ 1 (size (get-right-subtree tree)) (size (get-left-subtree tree))))
    )
)

(defun height (tree); gibt höhe des (Teil)Baums zurück
    (cond
        ((null (get-value tree)) 0)
        (T (+ 1 (max (height (get-right-subtree tree)) (height (get-left-subtree tree)))))
    )
)

(defun is-empty (tree); gibt T oder nil zurück
    (null (get-value tree))
)

(defun get-max (tree); gibt maximalen Wert im (Teil)Baum zurück
    (cond
        ((null (get-value tree)) nil)
        (T (if (null (get-max (get-right-subtree tree) )) (get-value tree) (get-max (get-right-subtree tree) )))
    )
)

(defun get-min (tree); gibt minialen Wert im (Teil)Baum zurück
    (cond
        ((null (get-value tree)) nil)
        (T (if (null (get-min (get-left-subtree tree) )) (get-value tree) (get-min (get-left-subtree tree) )))
    )
)

(defun add-all (tree otherTree); fügt alle Elemente von tree und otherTree in einen neuen Baum ein und gibt diesen zurück
    (cond
        ((get-value otherTree) (add-all tree (get-left-subtree otherTree)) (add-all tree (get-right-subtree otherTree)) (insert tree (get-value otherTree)))
    )
)

(defun read-file-complete (filename); gibt eine Liste zurück mit allen Werten die aus der Datei gelesen wurden
    (with-open-file (stream filename :direction :input)
        (loop for line = (read stream nil 'eof)
            until(eql line 'eof)
            collect line
        )
    )
)

(defun insert-into-tree (tree l); fügt alle Werte die sich in der Liste befinden in den Baum ein
    (if (car l) (insert-into-tree (insert tree (car l)) (cdr l)) tree)
)

(defun insert-from-file (tree filename)
    (insert-into-tree tree (read-file-complete filename))
)

(defun print-levelorder (tree); gibt die Werte von tree in levelorder aus
    (print (stable-sort (levelorder tree 0) (lambda (l r) (< (second l) (second r)))))
)

(defun levelorder (tree level); gibt eine Liste von Tupeln zurück in der die Zahl und das Level steht
    (if (get-value tree)
        (append (list (list (get-value tree) level))
                (levelorder (get-left-subtree tree) (+ level 1))
                (levelorder (get-right-subtree tree) (+ level 1))
        )
    )
)

(defun my-remove (tree new-tree val); gibt Baum ohne val zurück, val wird ersetzt, wenn möglich durch den kleinsten Wert im rechten Teilbaum
        (cond
            ((null (get-value tree)) new-tree); Ein Blatt wurde erreicht (ende)

            ((eql (get-value tree) val); Der aktuelle Knoten hat den Wert, der entfernt werden soll
             (cond
                 ((null (get-right-subtree tree))
                  (cond
                      ((null (get-left-subtree tree)) new-tree); Der Knoten hat keine Kinder
                      (T; Der Knoten hat nur ein linkes Kind -> größter Wert im linken Teilbaum wird hochgezogen
                         (my-remove (get-left-subtree tree) (insert new-tree (get-max (get-left-subtree tree))) val))
                      )
                  )
                 (T ; Der Knoten hat ein reechtes Kind -> kleinster Wert im rechten Teilbaum wird hochgezogen, linker Teilbaum wird weiter durchsucht
                    (my-remove (get-left-subtree tree) (my-remove (get-right-subtree tree)(insert new-tree(get-min (get-right-subtree tree))) val) val))
              )
             )
            (T; Der aktuelle Knoten hat nicht den gesuchten Wert -> Wert wird zu new-tree hinzugefügt und Kinder werden durchsucht
                (my-remove (get-right-subtree tree) (my-remove (get-left-subtree tree) (insert new-tree (get-value tree)) val) val)
            )
        )
  )

(defun myRemove (tree val); gibt Baum ohne val zurück, val wird ersetzt, wenn möglich durch den kleinsten Wert im rechten Teilbaum
    (my-remove tree nil val)
)

(setq tree '())

(defun run (func); führt die gegebene funktion aus und speichert das Ergebnis in tree  
  (setq tree (eval func))
)
