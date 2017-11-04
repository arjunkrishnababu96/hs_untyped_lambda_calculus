-- type Variable = String
-- data Variable = Var Char deriving(Show)

import Data.List
-- replace :: String -> Char -> [Char] -> String
-- -- replace word ch ch_new = map (\letter -> if letter == ch then ch_new else letter) word
-- -- replace word ch ch_new = if  Data.List.elem ch word
-- --   then replace
-- --   else word
-- replace [] _ _ = []
-- replace (x:xs) ch ch_new = if x == ch
--   then ch_new ++ (replace xs ch ch_new)
--   else x:(replace xs ch ch_new)

data Term = Var String
  | Lambda String Term
  | Application Term Term
  deriving (Show, Eq)

subst :: Term -> Term -> Term -> Term
-- [x -> s]y
subst (Var x) (Var y) s = if x == y
  then s
  else (Var y)
subst x (Application t1 t2) s = Application (subst x t1 s) (subst x t2 s)

-- subst x (Lambda y t) s = Lambda y (subst x t s) --problematic

-- this is the capture-avoiding part
subst (Var x) (Lambda y t) (Var s) = if s == y
  then Var x  -- INCORRECT!
  else Lambda y (subst (Var x) t (Var s))

isValue :: Term -> Bool
isValue (Lambda _ _) = True
isValue _ = False

x = Var "x"
t = Lambda "z" x
yt = Lambda "y" x
y = Var "y"

appl = Application t yt


eval1 :: Term -> Maybe Term

-- E_APPABS: (Lx.t)v -> [x->v]t
eval1 (Application (Lambda x t) v2@(Lambda _ _)) = Just (subst (Var x) t v2)

-- E_APP2
eval1 (Application v1@(Lambda _ _) t2) = case (eval1 t2) of
  Just x -> Just (Application v1 x)
  otherwise -> Nothing
eval1 _ = Nothing

-- eval1 :: Term -> Term -> Maybe Term
-- eval1 (Lambda x t12) v2 = Just (subst (Var x) t12 v2) -- E_APPABS
-- eval1 _ _ = Nothing
-- eval1 t1 t2 = if isValue t1
--   then if isValue t2
--     then subst  -- E_APPABS
--     else expression -- E_APP2
--   else expression -- E_APP1

-- x = Var "x"
-- xx = Var "x"
-- y = Var "y"
-- z = Lambda "K" (Var "L")

a = Lambda "x" (Var "x")
aa = Lambda "x" (Var "g")
b = Var "y"
