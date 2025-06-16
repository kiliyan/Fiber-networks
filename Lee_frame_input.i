
[Mesh]
    [./lee_frame]
      type = FileMeshGenerator
      file = lee_frame_kadapa.e
      show_info = true
      [../]
[]


[Variables]
    [./disp_x]
      order = FIRST
      family = LAGRANGE 
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

        [./semi_fix_r1]
      type = DirichletBC
      variable = rot_x
      boundary = right
      value = 0.0
    [../]
    [./semi_fix_r2]
      type = DirichletBC
      variable = rot_y
      boundary = right
      value = 0.0
    [../]
    [./semi_fix_r3]
      type = DirichletBC
      variable = rot_z
      boundary = right
      value = 0.0
    [../]


    []

  [DiracKernels]
    [./point_source1]
      type = FunctionDiracSource
      variable = disp_y
      function = moment
     point = '24.0 0.0 0.0'
    [../]
  []

 # [NodalKernels]
 # [./point_source1]
 #   type = UserForcingFunctorNodalKernel
 #   variable = disp_y
 #   boundary = tip
 #   functor = moment
 # [../]
#[]


[Functions]
   [./moment_slash_force]
     type = PiecewiseLinear
     x='0 1'
     y='0 1'
   [../]
[]

#[./top]
#  type = VectorNeumannBC
#  variable = disp_y
#  vector_value = '1 1 0'
#  boundary = 'tip'
#[../]

#[./right2]
#  type = FunctionNeumannBC
#  variable = u
#  boundary = bottom
#  function = (y*(t-1))+1
#[../]

  [Kernels]  
  [./solid_disp_x]
    type = StressDivergenceBeam
    block =  'beam column'  # 'upper','lower'
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
      youngs_modulus = 720
      poissons_ratio = 0.3
      shear_coefficient = 1
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
      type = SMP
      full = true
    [../]
  []

 [Executioner]
    type = Transient
    line_search = 'basic'

    petsc_options = '-snes_ksp_ew -ksp_converged_reason -ksp_monitor_cancel  -pc_svd_monitor'
    petsc_options_iname = '-ksp_type -pc_type -snes_type'
    petsc_options_value = 'preonly lu newtonls'

    solve_type = NEWTON
    automatic_scaling = true   
    compute_scaling_once = false 

   #non linear iteration controls
    nl_max_its = 40
    nl_abs_tol = 1e-7

    # time control
    start_time = 0.0
    dt = .005
    dtmin = 0.001
    end_time = 1
  []

  [Postprocessors]
    [./disp_xtip]
       type = PointValue
       point = '0.0 0.0 0.0'
       variable = disp_x
     [../]

    [./disp_ytip]
       type = PointValue
       point = '0.0 0.0 0.0'
       variable = disp_y
     [../]


      [./disp_x_lp]
        type = PointValue
        point = '24.0 0.0 0.0'
        variable = disp_x
      [../]

     [./disp_y_lp]
        type = PointValue
        point = '24.0 0.0 0.0'
        variable = disp_y
      [../]

    [./rot_tip]
        type = PointValue
        point = '50.0 0.0 0.0'
        variable = rot_z
    [../]

     [./moment_value]
         type = FunctionValuePostprocessor
         function = moment_slash_force
     [../]
    []


  [Outputs]
    csv =  true
    append_date = true
    file_base = 'lee_frame_like_beam'
  []
