<%@page import="jakarta.servlet.http.HttpSession"%>
<%
    // Evitar cach� del navegador
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    HttpSession sesion = request.getSession(false);
    String contextPath = request.getContextPath();
    String requestURI = request.getRequestURI();

    // Validar sesi�n activa
    if (sesion == null || sesion.getAttribute("idRol") == null) {
        response.sendRedirect(contextPath + "/index.jsp");
        return;
    }

    // Obtener rol (num�rico)
    int idRol = (int) sesion.getAttribute("idRol");

    // Verificar rutas accedidas
    boolean accedeAdmin = requestURI.contains("/vistasAdmin/");
    boolean accedeConductor = requestURI.contains("/vistasEmpleado/");
    boolean accedeMecanico = requestURI.contains("/vistasMecanico/");

    // L�gica de restricci�n de acceso
    switch (idRol) {
        case 1: // ADMINISTRADOR
            if (accedeConductor || accedeMecanico) {
                response.sendRedirect(contextPath + "/vistasAdmin/inicio.jsp");
                return;
            }
            break;

        case 2: // CONDUCTOR
            if (accedeAdmin || accedeMecanico) {
                response.sendRedirect(contextPath + "/vistasEmpleado/empleadoMaquinas.jsp");
                return;
            }
            break;

        case 3: // MEC�NICO
            if (accedeAdmin || accedeConductor) {
                response.sendRedirect(contextPath + "/vistasMecanico/mecanico.jsp");
                return;
            }
            break;

        default:
            // Rol desconocido
            response.sendRedirect(contextPath + "/index.jsp");
            return;
    }
%>
