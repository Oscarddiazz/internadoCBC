-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 05-08-2025 a las 21:06:57
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `internadocbc`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documento`
--

CREATE TABLE `documento` (
  `doc_id` int(11) NOT NULL,
  `doc_nombre` varchar(255) NOT NULL,
  `doc_archivo` varchar(255) NOT NULL,
  `doc_fec_subida` datetime DEFAULT current_timestamp(),
  `doc_admin_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `documento`
--

INSERT INTO `documento` (`doc_id`, `doc_nombre`, `doc_archivo`, `doc_fec_subida`, `doc_admin_id`) VALUES
(1, 'Reglamento Interno', 'reglamento.pdf', '2025-08-03 16:39:18', 1),
(2, 'Manual de Convivencia', 'convivencia.pdf', '2025-08-03 16:39:18', 1),
(3, 'Calendario Académico 2023', 'calendario.pdf', '2025-08-03 16:39:18', 1),
(4, 'Guía de Seguridad Industrial', 'seguridad.pdf', '2025-08-03 16:39:18', 1),
(5, 'Protocolo COVID-19', 'covid.pdf', '2025-08-03 16:39:18', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entrega_comida`
--

CREATE TABLE `entrega_comida` (
  `entcom_id` int(11) NOT NULL,
  `entcom_fec_entrega` datetime DEFAULT current_timestamp(),
  `entcom_comida` enum('Desayuno','Almuerzo','Cena') NOT NULL,
  `entcom_delegado_id` int(11) NOT NULL,
  `entcom_aprendiz_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `entrega_comida`
--

INSERT INTO `entrega_comida` (`entcom_id`, `entcom_fec_entrega`, `entcom_comida`, `entcom_delegado_id`, `entcom_aprendiz_id`) VALUES
(1, '2025-08-03 16:38:06', 'Desayuno', 3, 4),
(2, '2025-08-03 16:38:06', 'Almuerzo', 3, 5),
(3, '2025-08-03 16:38:06', 'Cena', 4, 6),
(4, '2025-08-03 16:38:06', 'Desayuno', 4, 7),
(5, '2025-08-03 16:38:06', 'Almuerzo', 3, 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permiso`
--

CREATE TABLE `permiso` (
  `permiso_id` int(11) NOT NULL,
  `permiso_motivo` text NOT NULL,
  `permiso_evidencia` varchar(255) DEFAULT NULL,
  `permiso_fec_solic` datetime DEFAULT current_timestamp(),
  `permiso_fec_res` datetime DEFAULT NULL,
  `permiso_admin_id` int(11) NOT NULL,
  `permiso_aprendiz_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `permiso`
--

INSERT INTO `permiso` (`permiso_id`, `permiso_motivo`, `permiso_evidencia`, `permiso_fec_solic`, `permiso_fec_res`, `permiso_admin_id`, `permiso_aprendiz_id`) VALUES
(1, 'Consulta médica', 'medico.pdf', '2025-08-03 16:38:54', '2023-06-10 14:30:00', 1, 4),
(2, 'Problemas familiares', 'familia.pdf', '2025-08-03 16:38:54', NULL, 1, 5),
(3, 'Taller externo', 'taller.pdf', '2025-08-03 16:38:54', '2023-06-12 10:15:00', 1, 6),
(4, 'Emergencia familiar', NULL, '2025-08-03 16:38:54', NULL, 1, 7),
(5, 'Examen médico', 'examen.pdf', '2025-08-03 16:38:54', '2023-06-14 16:45:00', 1, 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tareas`
--

CREATE TABLE `tareas` (
  `tarea_id` int(11) NOT NULL,
  `tarea_descripcion` text NOT NULL,
  `tarea_fec_asignacion` datetime DEFAULT current_timestamp(),
  `tarea_fec_entrega` date NOT NULL,
  `tarea_estado` enum('Pendiente','En Proceso','Completada') NOT NULL,
  `tarea_evidencia` varchar(255) DEFAULT NULL,
  `tarea_fec_completado` datetime DEFAULT NULL,
  `tarea_admin_id` int(11) NOT NULL,
  `tarea_aprendiz_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `tareas`
--

INSERT INTO `tareas` (`tarea_id`, `tarea_descripcion`, `tarea_fec_asignacion`, `tarea_fec_entrega`, `tarea_estado`, `tarea_evidencia`, `tarea_fec_completado`, `tarea_admin_id`, `tarea_aprendiz_id`) VALUES
(1, 'Limpiar el aula de sistemas', '2025-08-03 16:38:25', '2023-06-15', 'Completada', 'ba19293ef2514ed4a96b0e9dd63ec49f_Captura_de_pantalla_2025-07-26_234152.png', '2025-08-03 18:35:38', 1, 4),
(2, 'Organizar materiales de taller', '2025-08-03 16:38:25', '2023-06-20', 'En Proceso', NULL, NULL, 1, 5),
(3, 'Preparar presentación sobre seguridad industrial', '2025-08-03 16:38:25', '2023-06-25', 'Completada', NULL, NULL, 1, 6),
(4, 'Actualizar inventario de herramientas', '2025-08-03 16:38:25', '2023-06-18', 'Pendiente', NULL, NULL, 1, 7),
(5, 'Realizar informe de actividades semanales', '2025-08-03 16:38:25', '2023-06-22', 'En Proceso', NULL, NULL, 1, 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `user_id` int(11) NOT NULL,
  `user_num_ident` varchar(50) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_ape` varchar(100) NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `user_tel` varchar(15) DEFAULT NULL,
  `user_pass` varchar(100) NOT NULL,
  `user_rol` enum('Administrador','Delegado','Aprendiz') NOT NULL,
  `user_discap` enum('Visual','Auditiva','Fisica','Ninguna') NOT NULL,
  `etp_form_Apr` enum('Lectiva','Productiva') NOT NULL,
  `user_gen` enum('Masculino','Femenino') NOT NULL,
  `user_etn` enum('Indigina','Afrodescendiente','No Aplica') NOT NULL,
  `user_img` varchar(250) NOT NULL,
  `fec_ini_form_Apr` date NOT NULL,
  `fec_fin_form_Apr` date NOT NULL,
  `ficha_Apr` int(11) NOT NULL,
  `fec_registro` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`user_id`, `user_num_ident`, `user_name`, `user_ape`, `user_email`, `user_tel`, `user_pass`, `user_rol`, `user_discap`, `etp_form_Apr`, `user_gen`, `user_etn`, `user_img`, `fec_ini_form_Apr`, `fec_fin_form_Apr`, `ficha_Apr`, `fec_registro`) VALUES
(1, '1007890123', 'Pedro', 'Suárez Jiménez', 'pedro.suarez@sena.edu.co', '3127890123', 'admin123', 'Administrador', 'Ninguna', 'Lectiva', 'Masculino', 'No Aplica', 'admin.jpg', '2023-01-01', '2023-12-31', 0, '2025-08-03 16:37:50'),
(2, '1003456789', 'Juan', 'Martínez García', 'juan.martinez@sena.edu.co', '3203456789', 'delegado1', 'Delegado', 'Ninguna', 'Lectiva', 'Masculino', 'Indigina', 'delegado1.jpg', '2023-01-16', '2023-12-15', 123456, '2025-08-03 16:37:50'),
(3, '1009012345', 'Andrés', 'Vargas Rojas', 'andres.vargas@sena.edu.co', '3189012345', 'delegado2', 'Delegado', 'Ninguna', 'Lectiva', 'Masculino', 'No Aplica', 'delegado2.jpg', '2023-01-16', '2023-12-15', 123456, '2025-08-03 16:37:50'),
(4, '1001234567', 'Carlos', 'Gómez Pérez', 'carlos.gomez@sena.edu.co', '3101234567', 'aprendiz1', 'Aprendiz', 'Ninguna', 'Lectiva', 'Masculino', 'No Aplica', 'aprendiz1.jpg', '2023-01-16', '2023-12-15', 123456, '2025-08-03 16:37:50'),
(5, '1002345678', 'María', 'Rodríguez López', 'maria.rodriguez@sena.edu.co', '3152345678', 'aprendiz2', 'Aprendiz', 'Visual', 'Productiva', 'Femenino', 'Afrodescendiente', 'aprendiz2.jpg', '2023-02-01', '2023-11-30', 234567, '2025-08-03 16:37:50'),
(6, '1004567890', 'Ana', 'Hernández Vargas', 'ana.hernandez@sena.edu.co', '3004567890', 'aprendiz3', 'Aprendiz', 'Fisica', 'Productiva', 'Femenino', 'No Aplica', 'aprendiz3.jpg', '2023-03-01', '2024-02-28', 345678, '2025-08-03 16:37:50'),
(7, '1005678901', 'Luis', 'Díaz Ramírez', 'luis.diaz@sena.edu.co', '3015678901', 'aprendiz4', 'Aprendiz', 'Ninguna', 'Lectiva', 'Masculino', 'No Aplica', 'aprendiz4.jpg', '2023-01-16', '2023-12-15', 123456, '2025-08-03 16:37:50'),
(8, '1006789012', 'Sofía', 'Moreno Castro', 'sofia.moreno@sena.edu.co', '3176789012', 'aprendiz5', 'Aprendiz', 'Auditiva', 'Productiva', 'Femenino', 'Afrodescendiente', 'aprendiz5.jpg', '2023-02-01', '2023-11-30', 234567, '2025-08-03 16:37:50'),
(9, '1008901234', 'Laura', 'García Méndez', 'laura.garcia@sena.edu.co', '3148901234', 'aprendiz6', 'Aprendiz', 'Ninguna', 'Productiva', 'Femenino', 'Indigina', 'aprendiz6.jpg', '2023-03-01', '2024-02-28', 345678, '2025-08-03 16:37:50'),
(10, '1010123456', 'Diana', 'Castillo Ruiz', 'diana.castillo@sena.edu.co', '3130123456', 'aprendiz7', 'Aprendiz', 'Ninguna', 'Productiva', 'Femenino', 'No Aplica', 'aprendiz7.jpg', '2023-02-01', '2023-11-30', 234567, '2025-08-03 16:37:50');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `documento`
--
ALTER TABLE `documento`
  ADD PRIMARY KEY (`doc_id`),
  ADD KEY `doc_admin_id` (`doc_admin_id`);

--
-- Indices de la tabla `entrega_comida`
--
ALTER TABLE `entrega_comida`
  ADD PRIMARY KEY (`entcom_id`),
  ADD KEY `entcom_delegado_id` (`entcom_delegado_id`),
  ADD KEY `entcom_aprendiz_id` (`entcom_aprendiz_id`);

--
-- Indices de la tabla `permiso`
--
ALTER TABLE `permiso`
  ADD PRIMARY KEY (`permiso_id`),
  ADD KEY `permiso_admin_id` (`permiso_admin_id`),
  ADD KEY `permiso_aprendiz_id` (`permiso_aprendiz_id`);

--
-- Indices de la tabla `tareas`
--
ALTER TABLE `tareas`
  ADD PRIMARY KEY (`tarea_id`),
  ADD KEY `tarea_admin_id` (`tarea_admin_id`),
  ADD KEY `tarea_aprendiz_id` (`tarea_aprendiz_id`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_num_ident` (`user_num_ident`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `documento`
--
ALTER TABLE `documento`
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `entrega_comida`
--
ALTER TABLE `entrega_comida`
  MODIFY `entcom_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `permiso`
--
ALTER TABLE `permiso`
  MODIFY `permiso_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tareas`
--
ALTER TABLE `tareas`
  MODIFY `tarea_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `documento`
--
ALTER TABLE `documento`
  ADD CONSTRAINT `documento_ibfk_1` FOREIGN KEY (`doc_admin_id`) REFERENCES `usuario` (`user_id`);

--
-- Filtros para la tabla `entrega_comida`
--
ALTER TABLE `entrega_comida`
  ADD CONSTRAINT `entrega_comida_ibfk_1` FOREIGN KEY (`entcom_delegado_id`) REFERENCES `usuario` (`user_id`),
  ADD CONSTRAINT `entrega_comida_ibfk_2` FOREIGN KEY (`entcom_aprendiz_id`) REFERENCES `usuario` (`user_id`);

--
-- Filtros para la tabla `permiso`
--
ALTER TABLE `permiso`
  ADD CONSTRAINT `permiso_ibfk_1` FOREIGN KEY (`permiso_admin_id`) REFERENCES `usuario` (`user_id`),
  ADD CONSTRAINT `permiso_ibfk_2` FOREIGN KEY (`permiso_aprendiz_id`) REFERENCES `usuario` (`user_id`);

--
-- Filtros para la tabla `tareas`
--
ALTER TABLE `tareas`
  ADD CONSTRAINT `tareas_ibfk_1` FOREIGN KEY (`tarea_admin_id`) REFERENCES `usuario` (`user_id`),
  ADD CONSTRAINT `tareas_ibfk_2` FOREIGN KEY (`tarea_aprendiz_id`) REFERENCES `usuario` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
