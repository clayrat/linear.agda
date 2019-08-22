module Typed.LTLCRef where

open import Data.List.All
open import Data.List.Relation.Ternary.Interleaving.Propositional
open import Relation.Unary hiding (_∈_)
open import Function
open import Category.Monad

open import Relation.Unary.Separation 
open import Relation.Unary.Separation.Construct.List as L

open import Prelude hiding (Lift)

open L.LinearEnv

data Ty : Set where
  nat  : Ty
  unit : Ty
  ref  : Ty → Ty
  _⊸_  : (a b : Ty) → Ty

Ctx  = List Ty
CtxT = List Ty → List Ty

open import Relation.Unary.Separation.Construct.Auth Ctx

infixr 20 _◂_
_◂_ : Ty → CtxT → CtxT
(x ◂ f) Γ = x ∷ f Γ

Just : Ty → Pred Ctx _
Just t = Exactly (t ∷ ε)

variable a b : Ty

data Exp : Ty → Ctx → Set where
  num   : ∀[ Emp ⇒ Exp nat ]
  lam   : ∀[ (a ◂ id ⊢ Exp b) ⇒ Exp (a ⊸ b) ]
  app   : ∀[ Exp (a ⊸ b) ✴ Exp a ⇒ Exp b ]
  var   : ∀[ Just a ⇒ Exp a ]
  ref   : ∀[ Exp a ⇒ Exp (ref a) ]
  deref : ∀[ Exp (ref a) ⇒ Exp a ]
  asgn  : ∀[ Exp (ref a) ✴ Exp (a ⊸ b) ⇒ Exp (ref b) ]

-- store types
ST = List Ty

mutual
  -- typed stores
  St : Pred Auth 0ℓ
  St = Lift (Allstar Val)

  -- values
  data Val : Ty → Pred ST 0ℓ where
    unit  :     ε[ Val unit ]
    num   : ℕ → ε[ Val nat  ]
    clos  : ∀ {Γ} → Exp b Γ → ∀[ Env Val Γ ⇒ Val (a ⊸ b) ]
    ref   : ∀[ Just a ⇒ Val a ]

M : ∀ {p} → Ctx → Ctx → Pred Auth p → Pred Auth p
M Γ₁ Γ₂ P =
  (○ (Env Val Γ₁)) ─✴
  St ==✴
  P ✴ (○ (Env Val Γ₂)) ✴ St

return : ∀ {p} {Γ} {P : Pred Auth p} → ∀[ P ⇒ M Γ Γ P ]
return Px env σ₁ st σ₂ =
  let (_ , σ₃ , σ₄) = ⊎-assoc σ₁ σ₂ in
  ⤇-return (Px ×⟨ {!⊎-assoc ? ?!} ⟩ env ×⟨ {!!} ⟩ st) {!!}

eval : ∀ {Γ} → Exp a Γ →  ∀[ M Γ ε (○ (Val a)) ]
eval (num x) = {!!}
eval (lam e) = {!!}
eval (app f✴e) = {!!}
eval (var x) = {!!}
eval (ref e) = {!!}
eval (deref e) = {!!}
eval (asgn e₁✴e₂) = {!!}
