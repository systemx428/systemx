  
  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    // dynamic function pointer resolution
    exists(VariableCall vc, int i,Function f | 
      pred.asExpr().(VariableAccess) = vc.getArgument(i)
      and
      f = getTarget(vc)
      and
      f.getParameter(i) = succ.asParameter()
      )
    // additional taint steps that are required for our purposes
    or
    (
      pred.asExpr() = succ.asExpr().(PointerFieldAccess).getQualifier()
    )
  }
  
}

module IndirectionCallFlow = TaintTracking::Global<IndirectFunctionCallConfiguration>;

from DataFlow::Node source, DataFlow::Node sink, int i, Function f, AssignExpr ae
where IndirectionCallFlow::flow(source, sink)
    and
    source.asParameter().getFunction() = f
    and
    f.getParameter(i) = source.asParameter()
    and
    ae = sink.asExpr().getParent*()
//select sink, i.toString() + " | " + ae.getLocation().getFile().toString() + " | " + ae.getLocation().getStartLine()