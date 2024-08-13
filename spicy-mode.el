(defcustom spicy-indent-offset 4
  "Number of spaces for each indentation step in `spicy-mode'."
  :version "0.1"
  :type 'integer
  :safe 'intergerp)

(defvar spicy--treesit-font-lock-rules
  (treesit-font-lock-rules

   :language 'spicy
   :feature 'comment
   '((comment) @font-lock-comment-face)

   :language 'spicy
   :feature 'string
   '((string) @font-lock-string-face
     (string) @contextual) ; Contextual special treatment.

   :language 'spicy
   :feature 'keyword
   '((type_decl ("type") @font-lock-keyword-face)
     (module_decl ("module") @font-lock-keyword-face)
     (enum_decl ("enum") @font-lock-keyword-face)
     (enum_decl ("enum") @font-lock-keyword-face)
     ((visibility) @font-lock-keyword-face)
     (enum_decl ("type") @font-lock-keyword-face)
     (attribute attribute_name: (attribute_name) @font-lock-keyword-face)
     (bitfield ("bitfield") @font-lock-keyword-face)
     (throw_ ("throw") @font-lock-keyword-face)
     (var_decl (linkage) @font-lock-keyword-face)
     (function_decl ("function") @font-lock-keyword-face)
     (while ("while") @font-lock-keyword-face)
     (return ("return") @font-lock-keyword-face)
     (hook_decl ("on") @font-lock-keyword-face)
     (hook_decl name: (hook_name) @font-lock-keyword-face)
     (field_decl skip: (is_skip) @font-lock-keyword-face)
     (unit_switch ("switch") @font-lock-keyword-face)
     )

   :language 'spicy
   :feature 'preprocessor
   '((import ("import") @font-lock-preprocessor-face))

   :language 'spicy
   :feature 'constant
   '(((integer) @font-lock-constant-face)
     (unit_switch_case (expression) @font-lock-constant-face)
     (unit_switch_case (expression) @font-lock-constant-face))

   :language 'spicy
   :feature 'type
   '((type_decl name: (ident) @font-lock-type-face)
     (typename (ident) @font-lock-type-face)
     (cast (ident) @font-lock-type-face)
     (enum_decl name: (ident) @font-lock-type-face)
     ("unit" @font-lock-type-face))

   :language 'spicy
   :feature 'variable
   '((field_decl name: (ident) @font-lock-variable-name-face)
     (enum_label name: (ident) @font-lock-variable-name-face)
     (bitfield_field name: (ident) @font-lock-variable-name-face)
     (var_decl name: (ident) @font-lock-variable-name-face)
     (params (ident) @font-lock-variable-name-face)
     (function_arg arg: (ident) @font-lock-variable-name-face))

   :language 'spicy
   :feature 'function-name
   '((function_decl name: (ident) @font-lock-function-name-face))
  )

  "Spicy font-lock settings.")

(define-derived-mode spicy-mode prog-mode "Spicy"
  "A mode for the Spicy programming language"
  (unless (treesit-ready-p 'spicy)
    (error "Tree-sitter for Spicy is not available"))

  (treesit-parser-create 'spicy)

  (setq-local comment-start "# ")
  (setq-local comment-end "")
  (setq-local comment-start-skip (rx "#" (* (syntax whitespace))))

  (setq-local treesit-font-lock-settings spicy--treesit-font-lock-rules)
  (setq-local treesit-font-lock-feature-list
              '((comment string)
                (keyword preprocessor)
                (constant type variable function-name)))

  (treesit-major-mode-setup))

(provide 'spicy-mode)
