# Decisiones de esta conversación — seguimiento

Actualizado el 11 de octubre de 2026. Índice de los acuerdos conversados y su estado; los detalles y el histórico están en [DISENO.md](../DISENO.md), que sigue siendo la fuente de diseño. Esta recopilación corrige notas que habían quedado solo en local. No todos los acuerdos implican cambios ya implementados.

| Tema | Decisión o dirección | Estado |
|---|---|---|
| Agua y casa exterior | Agua turquesa pixel art y casa granjera según referencias; casa ajustada a escala de personajes | Recursos e integración de prueba existentes; agua estática |
| Escala de personajes | Mismo formato/escala conservando estaturas; protagonista con más acciones; seis NPC con ocho vistas sin equipo | Integrados; acabado visual sujeto a revisión, catálogos actuales de main prevalecen |
| Enano | Joven para su especie, pelo/barba largos, siempre casco; presencia curtida, oficio minero/herrero; detalles propios de Bītu | Personaje creado; no copiar literalmente Gimli ni convertir herramienta en arma personal |
| Cocinero/pescador | Anciano, excéntrico con referencia Radagast y detalles propios | Personaje y parcela con choza/cobertizo creados |
| Elfa/comerciante | Elfa estudiosa, muy inteligente, recuerda desde nacimiento, no distraída; Arthas referencia física de pareja | Personajes creados; funciones finales pendientes |
| Cabezas estilizadas | Ajuste solicitado a comerciante y también dragón, todas sus vistas/acciones | Requisito publicado; revisar resultado vigente sin sobrescribir nuevos ajustes con arte local antiguo |
| Geografía inicial | Herrería lejos en noroeste; enano de visita con Flavia al comenzar | Diseño; posiciones de NPC en prueba todavía provisionales |
| Inicio amplio | Ruinas → sendero largo → astillero; compartir zona no significa comprimir distancias | Fuentes y variantes; nivel definitivo pendiente |
| Terraza alta | Segundo acceso a ruinas; mena bloquea al principio y obliga a terraza media/astillero | Preferencia registrada; ruptura permanente con herramienta es propuesta, sin implementar |
| Cancelación | Moverse cancela acciones; al repetir animación desde inicio, sin eventos tardíos ni estado roto | Requisito universal; no afirmar cobertura completa del código actual |
| Colisiones | Bloqueo estable en estructuras, límites, NPC y recursos, sin minisaltos | Revisión global requerida; mejoras parciales no equivalen a validación global |
| Reposo diagonal | Mantener diagonal intencional al soltar teclas, sin giro cardinal por diferencia breve; cambios deliberados siguen respondiendo | Corrección global pendiente de comprobar |
| Ruinas/camino y suelos | Reutilizar assets existentes; hierba, tierra y arena, sin duplicarlos | Suelos integrados; módulos de ruinas/camino requieren preparación/integración |
| Astillero | Exterior/interior de taller y vivienda de Flavia en su terreno | Fuentes creadas; casa independiente acogedora, dormitorio separado y cocina/salón confirmados |
| Museo | Exterior/interior; posible ampliar si falta sitio conservando colección | Fuentes creadas; ampliaciones y desbloqueo sin implementar |
| BITU24H | Ese nombre no implica abrir24h; tienda y museo separados en zona común | Fuentes creadas; horario pendiente |
| Vivienda de pareja | Compartida y anexa a BITU24H, con acceso doméstico | Exterior/interior creados; sin integrar |
| Alquimista | Casa exterior/interior con espacio doméstico y laboratorio | Fuentes creadas; sin integrar |
| Pescador/cocinero | Parcela con pesca, choza/cama y espacio de cocina/pesca | Cinco fuentes; cobertizo abierto puede permanecer exterior sin transición |
| Mina y herrería | Mina próxima y vivienda anexa al taller; dormir separado del calor | Cinco fuentes; sin integrar |
| Amplitud de interiores | Más suelo útil y separación, misma escala de personas/muebles | Criterio para todos; primera prueba en casa propia |
| Casa propia | Inicialmente habitable, modesta/abierta, rincón de cocina, cama/mesa y cofre oculto de semillas/carta | Interior integrado en prueba; objetos decorativos, no nuevos sistemas/lore |
| Barco | Diseño delegado: pequeño velero de trabajo; cubierta transitable e interior solo tras mejora posterior | Vistas/cubierta creadas; navegación sin implementar |
| Equipo faltante | Regadera/punto de agua/mochila, riego y kit portátil | Fuentes creadas; fases no equivalen a animaciones listas |
| Accesos | Fundido breve, puntos seguros, estado conservado; abierto se recorre andando | Casa E/fundido implementada; plan general de zonas/carga pendiente |
| Estructuras | Sin huecos residuales detrás/lados/esquinas; pasos solo si deliberados y legibles | Criterio anotado; revisar al colocar cada estructura |
| Forma de zonas | Sin rombo universal: granja horizontal, norte vertical, este/oeste horizontal; interiores según planta | Acuerdo; modificación del contorno de la prueba pendiente |
| Terminación de Bītu | Fuentes de lugares principales cubiertas no significa isla jugable completa | Integración, rutas, servicios, arte futuro y validación pendientes |

## Cómo mantener estas notas

Registrar decisiones, correcciones y requisitos al hablarlos, también cuando todavía no se programan. Distinguir confirmado/propuesto/pendiente y actualizar el estado después de cada implementación. Para este proyecto GitHub es el medio de revisión del usuario: una nota solo local no cumple esa necesidad. La petición actual autoriza publicar esta recopilación y los acuerdos omitidos; no interpretar este criterio como permiso ilimitado para futuras publicaciones o generación de arte.

[Auditoría de recursos](auditoria-assets-bitu.md) · [Casa integrada](casa-interior-prueba.md) · [Plan de interiores](transiciones-interiores.md)
