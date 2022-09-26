/* Copyright 2022 The StableHLO Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

#ifndef STABLHLO_REFERENCE_OPS_H
#define STABLHLO_REFERENCE_OPS_H

#include "stablehlo/dialect/StablehloOps.h"
#include "stablehlo/reference/Tensor.h"

namespace mlir {
namespace stablehlo {

Tensor eval(AddOp op, const Tensor &lhs, const Tensor &rhs);
Tensor eval(ConstantOp op, ElementsAttr value);
Tensor eval(SineOp op, const Tensor &operand);

}  // namespace stablehlo
}  // namespace mlir

#endif  // STABLHLO_REFERENCE_OPS_H