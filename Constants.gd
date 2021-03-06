extends Reference

const DEBUG = false

enum {DRAW_MODE_BLOB, DRAW_MODE_PRESSURE, DRAW_MODE_VISCOSITY}

const WIDTH = 2.5
const HEIGHT = 1.5

const SCALE = 400
const RENDER_WIDTH = SCALE * WIDTH
const RENDER_HEIGHT = SCALE * HEIGHT

const TIMESTEP = 0.016
const NUMBER_PARTICLES = 22

const REST_DENSITY = 1.0
const STIFFNESS = 1.5
const VISCOCITY = 0.3

const GRAVITY = 1.2

const PARTICLE_SPACING = 1.0 / NUMBER_PARTICLES
const PARTICLE_VOLUME = PARTICLE_SPACING * PARTICLE_SPACING
const PARTICLE_MASS = PARTICLE_VOLUME * REST_DENSITY
const KERNEL_RANGE = 1.25 * PARTICLE_SPACING

const MAX_NEIGHBORS = 10

const KERNEL_CONST = 315.0 / (64.0 * 3 * (KERNEL_RANGE*KERNEL_RANGE*KERNEL_RANGE*KERNEL_RANGE*KERNEL_RANGE*KERNEL_RANGE*KERNEL_RANGE*KERNEL_RANGE*KERNEL_RANGE))
const GRAD_KERNEL_CONST = 45.0 / (PI * (KERNEL_RANGE*KERNEL_RANGE*KERNEL_RANGE*KERNEL_RANGE*KERNEL_RANGE*KERNEL_RANGE))