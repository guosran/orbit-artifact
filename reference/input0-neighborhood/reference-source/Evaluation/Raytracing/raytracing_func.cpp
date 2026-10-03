// Raytracing benchmark for AMOEBA evaluation.
//
// Reference:
// - Streaming-Bench, commit 333782f78d5475c8b33b11ff2b9ba9d75c93ca49:
//   raytracing/application and the split kernels createRay, tractInt,
//   prioObj, detPos, getColor, and setColor.
// - Whitted, "An Improved Illumination Model for Shaded Display",
//   Communications of the ACM, 1980.
//
// This fixed-point version keeps the application-level raytracing stages:
// primary ray construction, approximate primitive intersections, nearest-hit
// selection, hit material lookup, per-light diffuse/shadow evaluation, and
// final color composition. The intersection and shadow tests are intentionally
// lightweight so each task remains mappable on a small 2x2 tile array.
//
// Expected task count after affine-to-taskflow: 27 top-level loop nests.

#define MAX_PIXELS 2304
#define IMAGE_WIDTH 64
#define SPHERE_COUNT 8
#define LIGHT_COUNT 4

void raytracing_func(
    int pixel_count, const int sphere_x[SPHERE_COUNT],
    const int sphere_y[SPHERE_COUNT], const int sphere_z[SPHERE_COUNT],
    const int sphere_radius[SPHERE_COUNT], const int sphere_r[SPHERE_COUNT],
    const int sphere_g[SPHERE_COUNT], const int sphere_b[SPHERE_COUNT],
    const int light_x[LIGHT_COUNT], const int light_y[LIGHT_COUNT],
    const int light_z[LIGHT_COUNT], int pixel_x[MAX_PIXELS],
    int pixel_y[MAX_PIXELS], int ray_dx[MAX_PIXELS], int ray_dy[MAX_PIXELS],
    int ray_dz[MAX_PIXELS], int ray_length[MAX_PIXELS],
    int ray_dir_x[MAX_PIXELS], int ray_dir_y[MAX_PIXELS],
    int ray_dir_z[MAX_PIXELS], int sphere_hit[MAX_PIXELS][SPHERE_COUNT],
    int plane_hit[MAX_PIXELS], int hit_object[MAX_PIXELS],
    int hit_dist[MAX_PIXELS], int hit_x[MAX_PIXELS], int hit_y[MAX_PIXELS],
    int hit_z[MAX_PIXELS], int normal_x[MAX_PIXELS], int normal_y[MAX_PIXELS],
    int normal_z[MAX_PIXELS], int base_r[MAX_PIXELS], int base_g[MAX_PIXELS],
    int base_b[MAX_PIXELS], int diffuse0[MAX_PIXELS], int diffuse1[MAX_PIXELS],
    int diffuse2[MAX_PIXELS], int diffuse3[MAX_PIXELS], int shadow0[MAX_PIXELS],
    int shadow1[MAX_PIXELS], int shadow2[MAX_PIXELS], int shadow3[MAX_PIXELS],
    int light_sum[MAX_PIXELS], int shadow_sum[MAX_PIXELS],
    int pixel_r[MAX_PIXELS], int pixel_g[MAX_PIXELS], int pixel_b[MAX_PIXELS]) {
  // Stage outputs are caller-provided scratch buffers, matching the GCN and
  // Harris benchmark style. The explicit buffers keep the raytracing stages
  // visible to task construction instead of leaving cgeist to fold them into a
  // few very large loops.

  // Task 0: Pixel coordinate decode.
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    pixel_x[pixel] = pixel % IMAGE_WIDTH;
    pixel_y[pixel] = pixel / IMAGE_WIDTH;
  }

  // Task 1: Primary ray before normalization.
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    ray_dx[pixel] = (pixel_x[pixel] - IMAGE_WIDTH / 2) * 32;
    ray_dy[pixel] = (pixel_y[pixel] - IMAGE_WIDTH / 2) * 32;
    ray_dz[pixel] = 1024;
  }

  // Task 2: Approximate ray length.
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int ax = ray_dx[pixel] > 0 ? ray_dx[pixel] : -ray_dx[pixel];
    int ay = ray_dy[pixel] > 0 ? ray_dy[pixel] : -ray_dy[pixel];
    int az = ray_dz[pixel] > 0 ? ray_dz[pixel] : -ray_dz[pixel];
    ray_length[pixel] = ax + ay + az + 1;
  }

  // Task 3: Normalize primary ray.
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    ray_dir_x[pixel] = ray_dx[pixel] * 1024 / ray_length[pixel];
    ray_dir_y[pixel] = ray_dy[pixel] * 1024 / ray_length[pixel];
    ray_dir_z[pixel] = ray_dz[pixel] * 1024 / ray_length[pixel];
  }

  // Tasks 4-11: Sphere intersection kernels. Each task uses a one-dimensional
  // screen-space hit proxy and sphere depth instead of a full quadratic sphere
  // intersection, which keeps the ray/object-hit semantics while keeping each
  // body small enough for a 2x2 mapper.
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int miss = ray_dir_x[pixel] - sphere_x[0];
    int depth = sphere_z[0] - sphere_radius[0];
    sphere_hit[pixel][0] = miss < sphere_radius[0] ? depth : 0;
  }
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int miss = ray_dir_x[pixel] - sphere_x[1];
    int depth = sphere_z[1] - sphere_radius[1];
    sphere_hit[pixel][1] = miss < sphere_radius[1] ? depth : 0;
  }
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int miss = ray_dir_x[pixel] - sphere_x[2];
    int depth = sphere_z[2] - sphere_radius[2];
    sphere_hit[pixel][2] = miss < sphere_radius[2] ? depth : 0;
  }
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int miss = ray_dir_x[pixel] - sphere_x[3];
    int depth = sphere_z[3] - sphere_radius[3];
    sphere_hit[pixel][3] = miss < sphere_radius[3] ? depth : 0;
  }
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int miss = ray_dir_x[pixel] - sphere_x[4];
    int depth = sphere_z[4] - sphere_radius[4];
    sphere_hit[pixel][4] = miss < sphere_radius[4] ? depth : 0;
  }
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int miss = ray_dir_x[pixel] - sphere_x[5];
    int depth = sphere_z[5] - sphere_radius[5];
    sphere_hit[pixel][5] = miss < sphere_radius[5] ? depth : 0;
  }
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int miss = ray_dir_x[pixel] - sphere_x[6];
    int depth = sphere_z[6] - sphere_radius[6];
    sphere_hit[pixel][6] = miss < sphere_radius[6] ? depth : 0;
  }
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int miss = ray_dir_x[pixel] - sphere_x[7];
    int depth = sphere_z[7] - sphere_radius[7];
    sphere_hit[pixel][7] = miss < sphere_radius[7] ? depth : 0;
  }

  // Task 12: Ground-plane intersection.
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    plane_hit[pixel] = ray_dir_y[pixel] > 0 ? 4096 : (1 << 30);
  }

  // Task 13: Nearest primitive selection.
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int best_object = SPHERE_COUNT;
    int best_dist = plane_hit[pixel] > 0 ? plane_hit[pixel] : (1 << 30);
    for (int obj = 0; obj < SPHERE_COUNT; ++obj) {
      int dist = sphere_hit[pixel][obj];
      if (dist > 0 && dist < best_dist) {
        best_dist = dist;
        best_object = obj;
      }
    }
    hit_object[pixel] = best_object;
    hit_dist[pixel] = best_dist;
  }

  // Task 14: Hit position.
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    hit_x[pixel] = ray_dir_x[pixel] * hit_dist[pixel] / 1024;
    hit_y[pixel] = ray_dir_y[pixel] * hit_dist[pixel] / 1024;
    hit_z[pixel] = ray_dir_z[pixel] * hit_dist[pixel] / 1024;
  }

  // Task 15: Surface normal.
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    normal_x[pixel] = ray_dir_x[pixel];
    normal_y[pixel] = ray_dir_y[pixel];
    normal_z[pixel] = ray_dir_z[pixel];
  }

  // Task 16: Base material color lookup.
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int obj = hit_object[pixel] < SPHERE_COUNT ? hit_object[pixel] : 0;
    base_r[pixel] = sphere_r[obj];
    base_g[pixel] = sphere_g[obj];
    base_b[pixel] = sphere_b[obj];
  }

  // Tasks 17-18: Per-light diffuse contribution, two lights per task.
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int dot = normal_z[pixel] + light_z[0];
    diffuse0[pixel] = dot > 0 ? dot / 1024 : 0;

    dot = normal_z[pixel] + light_z[1];
    diffuse1[pixel] = dot > 0 ? dot / 1024 : 0;
  }

  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int dot = normal_z[pixel] + light_z[2];
    diffuse2[pixel] = dot > 0 ? dot / 1024 : 0;

    dot = normal_z[pixel] + light_z[3];
    diffuse3[pixel] = dot > 0 ? dot / 1024 : 0;
  }

  // Tasks 19-22: Per-light shadow tests against all spheres. These are kept as
  // one-light tasks because the inner object reduction is the hardest body for
  // a 2x2 mapper to place.
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int obj = hit_object[pixel];
    int radius = obj < SPHERE_COUNT ? sphere_radius[obj] : 0;
    int dx = light_x[0] - hit_x[pixel];
    int dy = light_y[0] - hit_y[pixel];
    dx = dx < 0 ? -dx : dx;
    dy = dy < 0 ? -dy : dy;
    shadow0[pixel] = dx + dy < radius ? 1 : 0;
  }

  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int obj = hit_object[pixel];
    int radius = obj < SPHERE_COUNT ? sphere_radius[obj] : 0;
    int dx = light_x[1] - hit_x[pixel];
    int dy = light_y[1] - hit_y[pixel];
    dx = dx < 0 ? -dx : dx;
    dy = dy < 0 ? -dy : dy;
    shadow1[pixel] = dx + dy < radius ? 1 : 0;
  }

  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int obj = hit_object[pixel];
    int radius = obj < SPHERE_COUNT ? sphere_radius[obj] : 0;
    int dx = light_x[2] - hit_x[pixel];
    int dy = light_y[2] - hit_y[pixel];
    dx = dx < 0 ? -dx : dx;
    dy = dy < 0 ? -dy : dy;
    shadow2[pixel] = dx + dy < radius ? 1 : 0;
  }

  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    int obj = hit_object[pixel];
    int radius = obj < SPHERE_COUNT ? sphere_radius[obj] : 0;
    int dx = light_x[3] - hit_x[pixel];
    int dy = light_y[3] - hit_y[pixel];
    dx = dx < 0 ? -dx : dx;
    dy = dy < 0 ? -dy : dy;
    shadow3[pixel] = dx + dy < radius ? 1 : 0;
  }

  // Task 23: Combine light contributions.
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    light_sum[pixel] = 64 + diffuse0[pixel] + diffuse1[pixel] +
                       diffuse2[pixel] + diffuse3[pixel];
  }

  // Task 24: Combine shadow masks.
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    shadow_sum[pixel] =
        shadow0[pixel] + shadow1[pixel] + shadow2[pixel] + shadow3[pixel] + 1;
  }

  // Task 25: Compose final RGB color.
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    pixel_r[pixel] = base_r[pixel] * light_sum[pixel] / shadow_sum[pixel];
    pixel_g[pixel] = base_g[pixel] * light_sum[pixel] / shadow_sum[pixel];
    pixel_b[pixel] = base_b[pixel] * light_sum[pixel] / shadow_sum[pixel];
  }

  // Task 26: Background fixup for rays that miss all primitives.
  for (int pixel = 0; pixel < pixel_count; ++pixel) {
    if (hit_dist[pixel] == (1 << 30)) {
      pixel_r[pixel] = 0;
      pixel_g[pixel] = 0;
      pixel_b[pixel] = 0;
    }
  }
}
