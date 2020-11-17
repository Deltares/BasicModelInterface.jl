# BasicModelInterface

[![Build Status](https://github.com/Deltares/BasicModelInterface.jl/workflows/CI/badge.svg)](https://github.com/Deltares/BasicModelInterface.jl/actions) 

[Basic Model Interface](https://bmi.readthedocs.io/) (BMI) specification for the
[Julia programming language](https://julialang.org/). This package contains all 41 functions
that are part of the BMI 2.0 specification. These functions are declared without any
methods, like so: `function initialize end`. They do have documentation that shows how they
should be used.

It is up to model specific implementations to extend the functions defined here, adding
methods for their own model type, such as:

```julia
using BasicModelInterface
const BMI = BasicModelInterface

# any type you created to represent your model
struct MyModel end

function BMI.update(model::MyModel)
    # write MyModel update implementation here
end
```

This package is not yet registered, and is currently being developed independently of
[Community Surface Dynamics Modeling System](https://csdms.colorado.edu/wiki/Main_Page)(CSDMS).
After it has been proven successful with several Julia BMI implementations, we should
consider proposing CSDMS adoption as well, to join the existing C, C++, Fortran and Python
specifications.

## Summary of BMI functions

Table below taken from https://bmi.readthedocs.io/en/latest/#the-basic-model-interface.

Function                | Description
------------------------|----------------------------------------------------------
initialize              | Perform startup tasks for the model.
update                  | Advance model state by one time step.
update_until            | Advance model state until the given time.
finalize                | Perform tear-down tasks for the model.
get_component_name      | Name of the model.
get_input_item_count    | Count of a model's input variables.
get_output_item_count   | Count of a model's output variables.
get_input_var_names     | List of a model's input variables.
get_output_var_names    | List of a model's output variables.
get_var_grid            | Get the grid identifier for a variable.
get_var_type            | Get the data type of a variable.
get_var_units           | Get the units of a variable.
get_var_itemsize        | Get the size (in bytes) of one element of a variable.
get_var_nbytes          | Get the total size (in bytes) of a variable.
get_var_location        | Get the grid element type of a variable.
get_current_time        | Current time of the model.
get_start_time          | Start time of the model.
get_end_time            | End time of the model.
get_time_units          | Time units used in the model.
get_time_step           | Time step used in the model.
get_value               | Get a copy of values of a given variable.
get_value_ptr           | Get a reference to the values of a given variable.
get_value_at_indices    | Get variable values at specific locations.
set_value               | Set the values of a given variable.
set_value_at_indices    | Set the values of a variable at specific locations.
get_grid_rank           | Get the number of dimensions of a computational grid.
get_grid_size           | Get the total number of elements of a computational grid.
get_grid_type           | Get the grid type as a string.
get_grid_shape          | Get the dimensions of a computational grid.
get_grid_spacing        | Get the spacing between grid nodes.
get_grid_origin         | Get the origin of a grid.
get_grid_x              | Get the locations of a grid's nodes in dimension 1.
get_grid_y              | Get the locations of a grid's nodes in dimension 2.
get_grid_z              | Get the locations of a grid's nodes in dimension 3.
get_grid_node_count     | Get the number of nodes in the grid.
get_grid_edge_count     | Get the number of edges in the grid.
get_grid_face_count     | Get the number of faces in the grid.
get_grid_edge_nodes     | Get the edge-node connectivity.
get_grid_face_edges     | Get the face-edge connectivity.
get_grid_face_nodes     | Get the face-node connectivity.
get_grid_nodes_per_face | Get the number of nodes for each face.

## Notes and open questions

This specification is adopted from the [BMI 2.0 Python specification](https://github.com/csdms/bmi-python/blob/v2.0/bmipy/bmi.py).
Instead of Python's class methods, the Julia specification expects a `model` parameter
as the first argument. Julia will dispatch to the right implementation based on the type
of the `model` parameter.

We do not apply the Julia convention to put a ! after mutating function names, to keep
the function names consistent with the other languages.

- Time must be a float.
- Grid is an integer grid identifier.
- Units should be string.

See if we can instead use richer types that keep more information,
yet still convert to the right `Int64`, `Float64`, `String`, etc.

`get_grid_shape`: Instead of passing in a `Vector` to fill, do not require a shape argument,
    and return a `Tuple`, like the `size` function.

https://bmi.readthedocs.io/en/latest/bmi.best_practices.html#best-practices

> Constructs and features that are natural for the language should be used when implementing
a BMI. BMI strives to be developer-friendly.

> BMI functions always use flattened, one-dimensional arrays. This avoids any issues stemming
from row/column-major indexing when coupling models written in different languages. It’s the
developer's responsibility to ensure that array information is flattened/redimensionalized
in the correct order.

From the above and the [get_grid_shape](https://bmi.readthedocs.io/en/latest/#get-grid-shape)
docs it is not quite clear yet what the correct order is. Flattening a row-array and a
column-major array will result in the same size but different order array.

> “ij” indexing (as opposed to “xy”)

Does `i` here stand for the first dimension, regardless of row/column-major indexing?

> the length of the z-dimension, nz, would be listed first.

If the z-dimension needs to go first, that means different z at the same xy location will
be close in memory for column-major, and far in memory for row-major.
