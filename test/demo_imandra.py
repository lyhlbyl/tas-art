import imandra
if __name__ == '__main__':

    with imandra.session() as s:
      # Defining a function
      s.eval("let f x = if x > 0 then if x * x < 0 then x else x + 1 else x")
      # Verifying some of its properties / solving constraints
      verify_result = s.verify("fun x -> x > 0 ==> f x > 0")
      instance_result = s.instance("fun x -> f x = 43")
      # Run a Region Decomposition
      decomposition = s.decompose("f")

      print(verify_result)
      print(instance_result)

      # Iterate over regions and print region constraints and invariants
      for n, region in enumerate(decomposition.regions):
        print("-"*10 + " Region", n, "-"*10 + "Constraints")
        for c in region.constraints_pp:
          print("  ", c)
          print("Invariant:", "", region.invariant_pp)