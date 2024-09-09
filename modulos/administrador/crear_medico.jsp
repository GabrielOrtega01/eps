<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Médico - EPS Securitas</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Estilos personalizados -->
    <style>
        /* Estilos para el cuerpo del formulario */
        body {
            background-color: #f8f9fa;
        }
        .container {
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-top: 50px;
        }
        /* Estilos para los botones */
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #545b62;
        }
        /* Estilos para el footer */
        .footer {
            background-color: #343a40;
            color: #ffffff;
            text-align: center;
            position: fixed;
            bottom: 0;
            width: 100%;
            padding: 15px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="mt-5 mb-4">Crear Nuevo Médico</h1>
        <!-- Formulario para crear un nuevo cliente -->
        <form action="" method="post">
            <div class="form-group">
                <label for="documento">Documento:</label>
                <input type="text" class="form-control" id="documento" name="documento" required>
            </div>
            <div class="form-group">
                <label for="nombre">Nombre:</label>
                <input type="text" class="form-control" id="nombre" name="nombre" required>
            </div>
            <div class="form-group">
                <label for="apellido">Apellido:</label>
                <input type="text" class="form-control" id="apellido" name="apellido" required>
            </div>

            <div class="form-group">
                <label for="especialidad">Especialidad:</label>
                <select class="form-control" id="especialidad" name="especialidad" required>
                    <option value="MedicinaGeneral">Medicina General/a</option>
                    <option value="Pediatria">Pediatría/a</option>
                    <option value="Cardiologia">Cardiología/a</option>
                    <option value="Dermatologia">Dermatología/a</option>
                </select>
            </div>
            <div class="form-group">
                <label for="clave">Clave:</label>
                <input type="password" class="form-control" id="clave" name="clave" required>
            </div>
            <!-- Agrega aquí los demás campos del formulario -->
            <button type="submit" class="btn btn-primary">Crear Médico</button>
            <!-- Botón de regresar -->
            <button type="button" class="btn btn-secondary" onclick="location.href='principal.jsp';">Volver</button>
        </form>
        <% 
            // Procesar el formulario para crear un nuevo cliente
            if ("POST".equals(request.getMethod())) {
                String documento = request.getParameter("documento");
                String nombre = request.getParameter("nombre");
                String apellido = request.getParameter("apellido");
                String clave = request.getParameter("clave");
                String especialidad = request.getParameter("especialidad");
                
                Connection conexion = null;
                PreparedStatement pstmt = null;
                
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");
                    
                    String insertSQL = "INSERT INTO medico (documento, nombre, apellido, especialidad, clave) VALUES (?, ?, ?, ?, ?)";
                    pstmt = conexion.prepareStatement(insertSQL);
                    pstmt.setString(1, documento);
                    pstmt.setString(2, nombre);
                    pstmt.setString(3, apellido);
                    pstmt.setString(4, especialidad);
                    pstmt.setString(5, clave);
                    
                    int filasInsertadas = pstmt.executeUpdate();
                    
                    if (filasInsertadas > 0) {
        %>
        <div class="alert alert-success mt-3">Médico creado exitosamente</div>
        <%          } else { %>
        <div class="alert alert-danger mt-3">Error al crear el cliente</div>
        <%          }
                } catch (ClassNotFoundException | SQLException e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (pstmt != null) pstmt.close();
                        if (conexion != null) conexion.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        %>
    </div>



    <!-- Bootstrap JS (opcional, si necesitas funcionalidades de Bootstrap) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
