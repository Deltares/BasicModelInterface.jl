using Test
using BasicModelInterface
const BMI = BasicModelInterface

@testset "BasicModelInterface.jl" begin

@testset "no BMI implementation" begin
    # test expected errors for unknown model
    struct UnknownModel end
    unknown_model = UnknownModel()
    @test_throws ErrorException BMI.initialize(unknown_model)
    @test_throws ErrorException BMI.initialize(unknown_model, "config_file")
    @test_throws MethodError BMI.initialize(unknown_model, "config_file", "one_too_many")
end

@testset "some BMI implementation" begin
    struct KnownModel
        waterlevel::Matrix{Float64}
    end

    function BMI.initialize(model::KnownModel)
        known_model.waterlevel[:] .= 0.0
    end

    known_model = KnownModel(ones(3, 4))
    @test all(isone, known_model.waterlevel)
    BMI.initialize(known_model)
    @test all(iszero, known_model.waterlevel)
end

@testset "interface functions are defined" begin
    # not necessarily correct parameters
    # only needed to check if the correct fallback function is defined
    # and throws an error
    struct MyModel end
    model = MyModel()
    time = 1.0
    name = "myparam"
    dest = zeros(5)
    inds = [1, 3, 5]
    value = 3.0
    grid = 2
    spacing = zeros(5)
    origin = zeros(2, 5)
    x = collect(4:0.1:5)
    y = collect(6:0.1:9)
    z = collect(10:0.1:13)
    edge_nodes = zeros(Int, 2, 5)
    face_edges = zeros(Int, 5)
    face_nodes = zeros(Int, 5)
    nodes_per_face = zeros(Int, 5)

    @test_throws ErrorException BMI.initialize(model)
    @test_throws ErrorException BMI.update(model)
    @test_throws ErrorException BMI.update_until(model, time)
    @test_throws ErrorException BMI.finalize(model)
    @test_throws ErrorException BMI.get_component_name(model)
    @test_throws ErrorException BMI.get_input_item_count(model)
    @test_throws ErrorException BMI.get_output_item_count(model)
    @test_throws ErrorException BMI.get_input_var_names(model)
    @test_throws ErrorException BMI.get_output_var_names(model)
    @test_throws ErrorException BMI.get_var_grid(model, name)
    @test_throws ErrorException BMI.get_var_type(model, name)
    @test_throws ErrorException BMI.get_var_units(model, name)
    @test_throws ErrorException BMI.get_var_itemsize(model, name)
    @test_throws ErrorException BMI.get_var_nbytes(model, name)
    @test_throws ErrorException BMI.get_var_location(model, name)
    @test_throws ErrorException BMI.get_current_time(model)
    @test_throws ErrorException BMI.get_start_time(model)
    @test_throws ErrorException BMI.get_end_time(model)
    @test_throws ErrorException BMI.get_time_units(model)
    @test_throws ErrorException BMI.get_time_step(model)
    @test_throws ErrorException BMI.get_value(model, name, dest)
    @test_throws ErrorException BMI.get_value_ptr(model, name)
    @test_throws ErrorException BMI.get_value_at_indices(model, name, dest, inds)
    @test_throws ErrorException BMI.set_value(model, name, value)
    @test_throws ErrorException BMI.set_value_at_indices(model, name, inds, value)
    @test_throws ErrorException BMI.get_grid_rank(model, grid)
    @test_throws ErrorException BMI.get_grid_size(model, grid)
    @test_throws ErrorException BMI.get_grid_type(model, grid)
    @test_throws ErrorException BMI.get_grid_shape(model, grid)
    @test_throws ErrorException BMI.get_grid_spacing(model, grid, spacing)
    @test_throws ErrorException BMI.get_grid_origin(model, grid, origin)
    @test_throws ErrorException BMI.get_grid_x(model, grid, x)
    @test_throws ErrorException BMI.get_grid_y(model, grid, y)
    @test_throws ErrorException BMI.get_grid_z(model, grid, z)
    @test_throws ErrorException BMI.get_grid_node_count(model, grid)
    @test_throws ErrorException BMI.get_grid_edge_count(model, grid)
    @test_throws ErrorException BMI.get_grid_face_count(model, grid)
    @test_throws ErrorException BMI.get_grid_edge_nodes(model, grid, edge_nodes)
    @test_throws ErrorException BMI.get_grid_face_edges(model, grid, face_edges)
    @test_throws ErrorException BMI.get_grid_face_nodes(model, grid, face_nodes)
    @test_throws ErrorException BMI.get_grid_nodes_per_face(model, grid, nodes_per_face)
end

end  # testset "BasicModelInterface.jl"
