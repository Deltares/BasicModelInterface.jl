module BasicModelInterface

"""
    initialize(model, [config_file])

Perform startup tasks for the model.

Perform all tasks that take place before entering the model's time
loop, including opening files and initializing the model state. Model
inputs are read from a text-based configuration file, specified by
`config_file`.

# Arguments
config_file : str, optional
    The path to the model configuration file.

# Notes
Models should be refactored, if necessary, to use a
configuration file. CSDMS does not impose any constraint on
how configuration files are formatted, although YAML is
recommended. A template of a model's configuration file
with placeholder values is used by the BMI.
"""
function initialize end

"""
    update(model)

Advance model state by one time step.

Perform all tasks that take place within one pass through the model's
time loop. This typically includes incrementing all of the model's
state variables. If the model's state variables don't change in time,
then they can be computed by the :func:`initialize` method and this
method can return with no action.
"""
function update end

"""
    update_until(model, time)

Advance model state until the given time.

The given `time` must be a model time later than the current model time.
"""
function update_until end

"""
    finalize(model)

Perform tear-down tasks for the model.

Perform all tasks that take place after exiting the model's time
loop. This typically includes deallocating memory, closing files and
printing reports.
"""
function finalize end

"""
    get_component_name(model)

Name of the component.
"""
function get_component_name end

"""
    get_input_item_count(model)

Count of a model's input variables.
"""
function get_input_item_count end

"""
    get_output_item_count(model)

Count of a model's output variables.
"""
function get_output_item_count end

"""
    get_input_var_names(model)

List of a model's input variables.

Input variable names must be CSDMS Standard Names, also known
as *long variable names*.

# Notes
Standard Names enable the CSDMS framework to determine whether
an input variable in one model is equivalent to, or compatible
with, an output variable in another model. This allows the
framework to automatically connect components.

Standard Names do not have to be used within the model.
"""
function get_input_var_names end

"""
    get_output_var_names(model)

List of a model's output variables.

Output variable names must be CSDMS Standard Names, also known
as *long variable names*.
"""
function get_output_var_names end

"""
    get_var_grid(model, name)

Get grid identifier integer for the given variable.

The `name` can be an input or output variable name, a CSDMS Standard Name.
"""
function get_var_grid end

"""
    get_var_type(model, name)

Get data type of the given variable.

The `name` can be an input or output variable name, a CSDMS Standard Name.
"""
function get_var_type end

"""
    get_var_units(model, name)

Get units of the given variable.

Standard unit names, in lower case, should be used, such as
``meters`` or ``seconds``. Standard abbreviations, like ``m`` for
meters, are also supported. For variables with compound units,
each unit name is separated by a single space, with exponents
other than 1 placed immediately after the name, as in ``m s-1``
for velocity, ``W m-2`` for an energy flux, or ``km2`` for an
area.

The `name` can be an input or output variable name, a CSDMS Standard Name.

# Notes
CSDMS uses the [UDUNITS](http://www.unidata.ucar.edu/software/udunits)
standard from Unidata.
"""
function get_var_units end

"""
    get_var_itemsize(model, name)

Get memory use for each array element in bytes.

The `name` can be an input or output variable name, a CSDMS Standard Name.
"""
function get_var_itemsize end

"""
    get_var_nbytes(model, name)

Get size, in bytes, of the given variable.

The `name` can be an input or output variable name, a CSDMS Standard Name.
"""
function get_var_nbytes end

"""
    get_var_location(model, name)

Get the grid element type that the a given variable is defined on.

The grid topology can be composed of *nodes*, *edges*, and *faces*.

- node: A point that has a coordinate pair or triplet: the most
    basic element of the topology.
- edge: A line or curve bounded by two nodes.
- face: A plane or surface enclosed by a set of edges. In a 2D
    horizontal application one may consider the word "polygon",
    but in the hierarchy of elements the word "face" is most common.

The `name` can be an input or output variable name, a CSDMS Standard Name.

# Returns
The grid location on which the variable is defined. Must be one of
`"node"`, `"edge"`, or `"face"`.

# Notes
CSDMS uses the [ugrid conventions](http://ugrid-conventions.github.io/ugrid-conventions)
to define unstructured grids.
"""
function get_var_location end

"""
    get_current_time(model)

Current time of the model.
"""
function get_current_time end

"""
    get_start_time(model)

Start time of the model.
"""
function get_start_time end

"""
    get_end_time(model)

End time of the model.
"""
function get_end_time end

"""
    get_time_units(model)

Time units of the model; e.g., `days` or `s`.

# Notes
CSDMS uses the [UDUNITS](http://www.unidata.ucar.edu/software/udunits)
standard from Unidata.
"""
function get_time_units end

"""
    get_time_step(model)

Current time step of the model.
"""
function get_time_step end

"""
    get_value(model, name, dest)

Get a copy of values of the given variable.

This is a getter for the model, used to access the model's
current state. It returns a *copy* of a model variable, with
the return type, size and rank dependent on the variable.

# Arguments
- `name`: An input or output variable name, a CSDMS Standard Name.
- `dest`: An array into which to place the values.

# Returns
The same array that was passed as an input buffer.
"""
function get_value end

"""
    get_value_ptr(model, name)

Get a reference to values of the given variable.

This is a getter for the model, used to access the model's
current state. It returns a reference to a model variable,
with the return type, size and rank dependent on the variable.

The `name` can be an input or output variable name, a CSDMS Standard Name.

Returns a reference to a model variable.
"""
function get_value_ptr end

"""
    get_value_at_indices(model, name, dest, inds)

Get values at particular indices.

# Arguments
- `name`: An input or output variable name, a CSDMS Standard Name.
- `dest`: An array into which to place the values.
- `inds`: The indices into the variable array.

# Returns
array_like
    Value of the model variable at the given location.
"""
function get_value_at_indices end

"""
    set_value(model, name, value)

Specify a new value for a model variable.

This is the setter for the model, used to change the model's
current state. It accepts, through *value*, a new value for a
model variable, with the type, size and rank of *value*
dependent on the variable.

# Arguments
- `name`: An input or output variable name, a CSDMS Standard Name.
- `value`: The new value for the specified variable.
"""
function set_value end

"""
    set_value_at_indices(model, name, inds, value)

Specify a new value for a model variable at particular indices.

# Arguments
- `name`: An input or output variable name, a CSDMS Standard Name.
- `inds`: The indices into the variable array.
- `value`: The new value for the specified variable.
"""
function set_value_at_indices end

# Grid information

"""
    get_grid_rank(model, grid)

Get number of dimensions of the computational grid.
"""
function get_grid_rank end

"""
    get_grid_size(model, grid)

Get the total number of elements in the computational grid.
"""
function get_grid_size end

"""
    get_grid_type(model, grid)

Get the grid type as a string.
"""
function get_grid_type end

# Uniform rectilinear

"""
    get_grid_shape(model, grid)

Get dimensions of the computational grid.
"""
function get_grid_shape end

"""
    get_grid_spacing(model, grid, spacing)

Get distance between nodes of the computational grid.

# Arguments
- `grid`: A grid identifier.
- `spacing`: An array to hold the spacing between grid rows and columns.

Returns the filled `spacing` array.
"""
function get_grid_spacing end

"""
    get_grid_origin(model, grid, origin)

Get coordinates for the lower-left corner of the computational grid.

# Arguments
- `grid`: A grid identifier.
- `origin`: An array to hold the coordinates of the lower-left corner of
    the grid.

Returns the filled `origin` array.
"""
function get_grid_origin end

# Non-uniform rectilinear, curvilinear

"""
    get_grid_x(model, grid, x)

Get coordinates of grid nodes in the x direction.

# Arguments
- `grid`: A grid identifier.
- `x`: An array to hold the x-coordinates of the grid nodes.

Returns the filled `x` array.
"""
function get_grid_x end

"""
    get_grid_y(model, grid, y)

Get coordinates of grid nodes in the y direction.

# Arguments
- `grid`: A grid identifier.
- `y`: An array to hold the y-coordinates of the grid nodes.

Returns the filled `y` array.
"""
function get_grid_y end

"""
    get_grid_z(model, grid, z)

Get coordinates of grid nodes in the z direction.

# Arguments
- `grid`: A grid identifier.
- `z`: An array to hold the z-coordinates of the grid nodes.

Returns the filled `z` array.
"""
function get_grid_z end

"""
    get_grid_node_count(model, grid)

Get the number of nodes in the grid.
"""
function get_grid_node_count end

"""
    get_grid_edge_count(model, grid)

Get the number of edges in the grid.
"""
function get_grid_edge_count end

"""
    get_grid_face_count(model, grid)

Get the number of faces in the grid.
"""
function get_grid_face_count end

"""
    get_grid_edge_nodes(model, grid, edge_nodes)

Get the edge-node connectivity.

# Arguments
- `grid`: A grid identifier.
- `edge_nodes`: An array of integers to place the edge-node connectivity.
    For each edge, connectivity is given as node at edge tail,
    followed by node at edge head. Therefore this array must be twice
    the number of nodes long.

Returns the filled `edge_nodes` array.
"""
function get_grid_edge_nodes end

"""
    get_grid_face_edges(model, grid, face_edges)

Get the face-edge connectivity.

# Arguments
- `grid`: A grid identifier.
- `face_edges`: An array of integers in which to place the face-edge connectivity.

Returns the filled `face_edges` array.
"""
function get_grid_face_edges end

"""
    get_grid_face_nodes(model, grid, face_nodes)

Get the face-node connectivity.

# Arguments
- `grid`: A grid identifier.
- `face_nodes`: An array of integers in which to place the face-node connectivity.
    For each face, the nodes (listed in a counter-clockwise direction) that form the
    boundary of the face.

Returns the filled `face_nodes` array.
"""
function get_grid_face_nodes end

"""
    get_grid_nodes_per_face(model, grid, nodes_per_face)

Get the number of nodes for each face.

# Arguments
- `grid`: A grid identifier.
- `nodes_per_face`: An array in which to place the number of edges per face.

Returns the filled `nodes_per_face` array.
"""
function get_grid_nodes_per_face end

end # module
