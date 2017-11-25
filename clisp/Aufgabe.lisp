(defun rotiere (l) ; Liefert eine neue Liste in der das vormals erste Element nun das letzte ist
(append (cdr l) (list (car l))))

(defun get-last (l) ; Liefert das letzte Element
(cond ((null (cdr l)) (car l)) (T (get-last (cdr l)))))

(defun but-last (l) ; Liefert eine neue Liste die das letzte Element nicht beinhaltet
(cond ((null (cdr l)) nil) (T (append (list (car l)) (but-last (cdr l))))))

(defun neues-vorletztes (e l) ; Liefert eine neue Liste mit dem Element e als vorletztes Element
(append (but-last l) (list e) (list (get-last l))))

(defun my-length (l) ; Liefert die Länge einer List
(cond ((null l) 0) (T (+ 1 (my-length (cdr l))))))

(defun my-lengthR (l) ; Liefert die Lange einer Liste und aller eingeschachtelten Listen
(cond ((null l) 0) ((listp (car l)) (+ (my-lengthR (car l)) (my-lengthR(cdr l)))) (T (+ 1 (my-lengthR (cdr l)))) ))

(defun my-reverse (l) ; zum Umkehren einer Liste
(cond ((null (cdr l)) (list(car l))) (T (append (my-reverse (cdr l)) (list(car l))))))

(defun my-reverseR (l) ; zum Umkehren einer Liste und aller Listen in der Liste
    (cond
        ((null (cdr l))
             (cond ((null (car l)) nil)
                   ((listp (car l)) (list (my-reverseR (car l))))
                   (T (list (car l)))
             )
         )
        (T (append (my-reverseR (cdr l))
             (cond ((listp (car l))
                   (list (my-reverseR (car l))))
                   (T (list (car l))) )
             )
         )
     )
 )

 (defun has-child (tree) ;testet ob ein Kindknoten existiert
     (and (not (null tree)) (listp tree)))

 (defun preorder (tree);gibt den Baum in preorder aus
     (cond ((listp tree)
         (print (car tree))
         (if (has-child (cadr tree))(preorder (cadr tree)))
         (if (has-child (caddr tree))(preorder (caddr tree))))
         (T (print '(NOT A TREE)))))

 (defun inorder (tree) ;gibt den Baum in inorder aus
     (cond ((listp tree)
         (if (has-child (cadr tree))(inorder (cadr tree)))
         (print (car tree))
         (if (has-child (caddr tree))(inorder (caddr tree))))
         (T (print '(NOT A TREE)))))

 (defun postorder (tree) ;gibt den Baum in postorder aus
     (cond ((listp tree)
         (if (has-child (cadr tree))(postorder (cadr tree)))
         (if (has-child (caddr tree))(postorder (caddr tree)))
         (print (car tree)))
         (T (print '(NOT A TREE)))))
