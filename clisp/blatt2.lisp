;gnu clisp 2.49

(defun get-value (tree)
    (cond
        ((integerp(second tree)) (second tree))
        (T nil)
    )
)

(defun get-left-subtree (tree)
    (first tree)
)

(defun get-right-subtree (tree)
    (third tree)
)

(defun insert (tree val)
    (cond
        ((null tree) (list '() val '()))
        ((eql (get-value tree) val) tree)
        ((< (get-value tree) val) (append (list(get-left-subtree tree)) (list (get-value tree)) (list(insert (get-right-subtree tree) val))))
        ((> (get-value tree) val) (append (list(insert (get-left-subtree tree) val)) (list (get-value tree)) (list(get-right-subtree tree))))
    )
)

(defun contains (tree val)
    (cond
        ((null (get-value tree)) nil)
        ((eql (get-value tree) val) T)
        ((< (get-value tree) val) (contains (get-right-subtree tree) val))
        ((> (get-value tree) val) (contains (get-left-subtree tree) val))
    )
)

(defun size (tree)
    (cond
        ((null (get-value tree)) 0)
        (T (+ 1 (size (get-right-subtree tree)) (size (get-left-subtree tree))))
    )
)

(defun height (tree)
    (cond
        ((null (get-value tree)) 0)
        (T (+ 1 (max (height (get-right-subtree tree)) (height (get-left-subtree tree)))))
    )
)

(defun is-empty (tree)
    (null (get-value tree))
)

(defun get-max (tree)
    (cond
        ((null (get-value tree)) nil)
        (T (if (null (get-max (get-right-subtree tree) )) (get-value tree) (get-max (get-right-subtree tree) )))
    )
)

(defun get-min (tree)
    (cond
        ((null (get-value tree)) nil)
        (T (if (null (get-min (get-left-subtree tree) )) (get-value tree) (get-min (get-left-subtree tree) )))
    )
)

(defun add-all (tree otherTree)
    (cond
        ((get-value otherTree) (add-all tree (get-left-subtree otherTree)) (add-all tree (get-right-subtree otherTree)) (insert tree (get-value otherTree)))
    )
)

(defun read-file-complete (filename)
    (with-open-file (stream filename :direction :input)
        (loop for line = (read stream nil 'eof)
            until(eql line 'eof)
            collect line
        )
    )
)

(defun insert-into-tree (tree l)
    (if (car l) (insert-into-tree (insert tree (car l)) (cdr l)) tree)
)

(defun insert-from-file (tree filename)
    (insert-into-tree tree (read-file-complete filename))
)

(defun print-levelorder (tree)
    (print (sort (levelorder tree 0) (lambda (l r) (< (second l) (second r)))))
)

(defun levelorder (tree level)
    (if (get-value tree)
        (append (list (list (get-value tree) level))
                (levelorder (get-left-subtree tree) (+ level 1))
                (levelorder (get-right-subtree tree) (+ level 1))
        )
    )
)

(defun remove-value (tree val)
    (get-parent-to-remove-value tree val)
)

(defun get-parent-to-remove-value (tree val)
    (cond
        ((eql (get-value tree) val) tree) ;was wenn root?
        (T (find-parent-to-remove-value tree val))
    )
)

(defun find-parent-to-remove-value (tree val)
    (cond
        ((> (get-value tree) val)
            (if (is-parent (get-left-subtree tree) val)
                (remove-value-from-parent tree (get-left-subtree tree))
                (find-parent-to-remove-value (get-left-subtree tree) val))
        )
        ((< (get-value tree) val)
            (if (is-parent (get-right-subtree tree) val)
                (remove-value-from-parent tree (get-right-subtree tree))
                (find-parent-to-remove-value (get-right-subtree tree) val))
        )
    )
)

(defun is-parent (tree val)
    (cond
        ((null (get-value tree)) T)
        ((eql (get-value tree) val) T)
        (T nil)
    )
)

(defun remove-value-from-parent (parent child)
    (cond
        ((null (get-value child)) nil)
        ((and (null (get-left-subtree child)) (null (get-right-subtree child))) ); remove nil value nil
    )
)

(print (remove-value '(((()2 ()) 5 ()) 10 (() 15 ())) 1))