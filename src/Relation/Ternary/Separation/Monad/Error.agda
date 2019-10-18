open import Relation.Unary
open import Relation.Ternary.Separation

module Relation.Ternary.Separation.Monad.Error {ℓ} {A : Set ℓ}
  {{r : RawSep A}}
  {u} {{_ : IsUnitalSep r u}}
  where

open import Level
open import Function
open import Data.Unit
open import Data.Sum
open import Relation.Unary renaming (U to True)
open import Relation.Unary.PredicateTransformer using (PT)
open import Relation.Ternary.Separation.Morphisms
open import Relation.Ternary.Separation.Monad
open import Relation.Binary.PropositionalEquality

record Err (P : Pred A ℓ) (Φ : A) : Set ℓ where
  constructor partial
  field
    runErr : (True ∪ P) Φ

open Err public

open Monads

instance
  err-monad : Monad ⊤ ℓ (λ _ _ → Err)
  runErr (Monad.return err-monad px) = inj₂ px
  app (Monad.bind err-monad f) (partial (inj₁ tt)) σ = partial (inj₁ tt)
  app (Monad.bind err-monad f) (partial (inj₂ y)) σ  = app f y σ

pattern error = partial (inj₁ tt)
pattern ✓ x   = partial (inj₂ x)