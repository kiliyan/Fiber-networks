# lee frame instability exercise (L frame consisting of one column and beam)
# modelled using timoshenko beam element


[Mesh]
    [./lee_frame]
      type = FileMeshGenerator
      file = lee_frame_mesh.e
      show_info = true
      [../]
[]

  
[Variables]
    [./disp_x]
      order = FIRST
      family = LAGRANGE #basis function family
    [../]
    [./disp_y]
      order = FIRST
      family = LAGRANGE
    [../]
    [./disp_z]
      order = FIRST
      family = LAGRANGE
    [../]
    [./rot_x]
      order = FIRST
      family = LAGRANGE
    [../]
    [./rot_y]
      order = FIRST
      family = LAGRANGE
    [../]
    [./rot_z]
      order = FIRST
      family = LAGRANGE
    [../]
[]

  [BCs]
    [./semi_fix_x1]
      type = DirichletBC
      variable = disp_x
      boundary = right
      value = 0.0
    [../]
    [./semi_fix_y1]
      type = DirichletBC
      variable = disp_y
      boundary = right
      value = 0.0
    [../]
    [./semi_fix_z1]
      type = DirichletBC
      variable = disp_z
      boundary = right
      value = 0.0
    [../]
    
    [./semi_fix_x1_bottom]
        type = DirichletBC
        variable = disp_x
        boundary = bottom
        value = 0.0
    [../]
    [./semi_fix_y1_bottom]
        type = DirichletBC
        variable = disp_y
        boundary = bottom
        value = 0.0
    [../]
    [./semi_fix_z1_bottom]
        type = DirichletBC
        variable = disp_z
        boundary = bottom
        value = 0.0
    [../]
   
    []
  
  [DiracKernels]
    [./point_source1]
      type = FunctionDiracSource
      variable = disp_y
      function = force
      point = '24.0 0.0 0.0'
    [../]
    []
  

  [Functions]
    [./force]
      type = PiecewiseLinear
      x='0 4'
      y='0 1' 
    [../]
  []

  [Kernels]  # define the governing equation 
  [./solid_disp_x]
    type = StressDivergenceBeam 
    block =  '1 2'  # 'upper','lower'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 0
    variable = disp_x
  [../]
  [./solid_disp_y]
    type = StressDivergenceBeam
    block = '1 2' 
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 1
    variable = disp_y
  [../]
  [./solid_disp_z]
    type = StressDivergenceBeam
    block = '1 2'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 2
    variable = disp_z
  [../]
  [./solid_rot_x]
    type = StressDivergenceBeam
    block = '1 2'  
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 3
    variable = rot_x
  [../]
  [./solid_rot_y]
    type = StressDivergenceBeam
    block = '1 2'  
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 4
    variable = rot_y
  [../]
  [./solid_rot_z]
    type = StressDivergenceBeam
    block = '1 2'  
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 5
    variable = rot_z
  [../]
[]

[Materials]
    [./elasticity]
      type = ComputeElasticityBeam
      youngs_modulus = 7.2e5
      poissons_ratio = 0.3
      shear_coefficient = 0.5
      block = '1 2'
    [../]


    [./strain_beam]
      type = ComputeFiniteBeamStrain
      block = '2'
      displacements = 'disp_x disp_y disp_z'
      rotations = 'rot_x rot_y rot_z'
      area = 6
      #Ax = 1e-3
      Iy = 2
      Iz = 2
      y_orientation = '0.0 1.0 0.0'
      large_strain = true
    [../]

    [./strain_column]
        type = ComputeFiniteBeamStrain
        block = '1'
        displacements = 'disp_x disp_y disp_z'
        rotations = 'rot_x rot_y rot_z'
        area = 6
        #Ax = 1e-3
        Iy = 2
        Iz = 2
        y_orientation = '1.0 0.0 0.0'
        large_strain = true
    [../]

    [./stress]
      type = ComputeBeamResultants
      block = '1 2'  
    [../]
  []
    
  [Preconditioning]
    [./smp]
      type = SMP #symmetric preconditioner
      full = true 
    [../]
  []

  [Executioner]
    type = Transient

    line_search = 'basic'
    # petsc_options = ' -ksp_monitor_cancel '
    petsc_options_iname = '-pc_type  -snes_type'
    petsc_options_value = 'lu newtonls'
  
    automatic_scaling = true
  
    # controls for linear iterations
    l_max_its = 10
    l_tol = 1e-10
  
    # controls for nonlinear iterations
    nl_max_its = 20
    nl_abs_tol = 1e-6
  
    # time control
    start_time = 0.0
    dt = .01
    dtmin = 0.005
    end_time = 4.01
  []
  


  [Outputs]
    exodus = true
    csv =  true
   #output_interval = 10 
  []