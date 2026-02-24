-- Ejecutar en Supabase SQL Editor.
-- Recomendado hacerlo primero en staging.

-- 1) Documento único por usuario
CREATE UNIQUE INDEX IF NOT EXISTS ux_usuarios_documento
ON public.usuarios (documento);

-- 2) Evitar más de un préstamo activo por ejemplar
CREATE UNIQUE INDEX IF NOT EXISTS ux_prestamo_activo_por_ejemplar
ON public.prestamos (id_ejemplar)
WHERE estado = 'activo';

-- 3) Índices de apoyo para consultas frecuentes
CREATE INDEX IF NOT EXISTS ix_prestamos_id_usuario_fecha
ON public.prestamos (id_usuario, fecha_prestamo DESC);

CREATE INDEX IF NOT EXISTS ix_ejemplares_libro_disponibilidad
ON public.ejemplares_libro (id_libro, disponibilidad);
