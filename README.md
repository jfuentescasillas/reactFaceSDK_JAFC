
# 1. Descripción de la solución

Se ha implementado una app iOS (UIKit) que demuestra el flujo completo pedido:

Inicializa el Regula FaceSDK (v. FaceSDK 7.2.3101 junto a RegulaCommon 8.2.1510).

Permite capturar un rostro usando el módulo de captura del SDK (FaceSDK.service.presentFaceCaptureViewController(...)). El flujo de captura y liveness lo entrega el SDK.

Permite seleccionar una imagen desde la galería (compatibilidad con PHPicker y UIImagePickerController) mediante una utilidad reutilizable ImagePicker.

Realiza una comparación del lado del usuario usando FaceSDK.service.matchFaces(...) y muestra la similitud como porcentaje en la UI.

Muestra feedback al usuario (spinner, mensajes de error) y permite reiniciar el flujo.

## Ficheros clave:

FaceViewController.swift — vista (UI): botones, imageViews, activity indicator, delegación del ImagePicker.

FacePresenter.swift — presenter (MVP): orquesta inicialización del SDK, captura, comparación y actualizaciones de la vista.

FaceSDKService.swift — adapter/service para FaceSDK: inicialización, presentación de captura y matchFaces.

ImagePicker.swift — helper reusable para seleccionar imágenes (action sheet, cámara/galería).

# 2. Patrones utilizados

MVP (Model-View-Presenter):

FaceViewController = View (gestiona UI y presentaciones),

FacePresenter = Presenter (lógica, orquestación),

FaceSDKService = Servicio/Adapter que encapsula llamadas al SDK (actúa como modelo/puente).

Dependency Injection (ligera): FacePresenter recibe FaceSDKServiceProtocol con implementación por defecto FaceSDKService(). Facilita tests/mocks.

Adapter/Façade: FaceSDKService actúa como fachada a la API del SDK, simplificando la interfaz para el Presenter.

Delegation: ImagePicker usa ImagePickerDelegate para devolver la imagen seleccionada a la View.

Defensive Concurrency: llamadas pesadas (matchFaces) ejecutadas en background; UI y completions en main thread.

# 3. Decisiones técnicas destacadas

## MVP en lugar de MVVM/Coordinator

Razón: claridad y separación simple para una prueba técnica. Presenter orquesta la lógica y la vista mantiene responsabilidades de UIKit.

Resultado: presenter testable (puede inyectarse un mock FaceSDKServiceProtocol).

## Servicio FaceSDKService

Centraliza initialize, presentFaceCapture y compareFaces. Evita que el presenter haga llamadas directas a FaceSDK y facilita el manejo de errores y threading.

Métodos importantes: initializeSDK, presentFaceCapture(from:completion:), compareFaces(_:_:completion:), deinitializeSDK().

## Threading consciente

matchFaces se ejecuta en DispatchQueue.global(qos:.userInitiated) para evitar bloquear el hilo principal (al probar la app, Xcode avisó que la SDK podría hacer checks sincrónicos). Se regresa a DispatchQueue.main para actualizar UI y ejecutar la completion.

presentFaceCapture y cualquier presentación de UI se ejecutan en el main thread.

## Desinicialización segura del SDK

Se llama presenter.stop() en FaceViewController.deinit para invocar FaceSDKService.deinitializeSDK(). Evita desinicializar mientras la vista está activa (problema que se produjo al intentar hacerlo en viewWillDisappear o en sceneDidEnterBackground en SceneDelegate).

## Compatibilidad con PHPicker / UIImagePicker

ImagePicker soporta PHPicker en iOS ≥14 y UIImagePickerController en versiones anteriores, incluyendo cámara y galería.

La View mapea la imagen devuelta al Presenter con didReceiveGalleryImage(_:).

## Manejo de resultados de comparación

Se obtiene similarity cuando está disponible; como fallback se usa score. Resultado se expone como valor en 0..1 y en la UI se multiplica por 100 para mostrar porcentaje.

## Gestión de errores y UX

showLoading(_:), showError(_:), resetUI() en FaceViewProtocol permiten feedback consistente.

Info.plist incluye NSCameraUsageDescription y NSPhotoLibraryUsageDescription.

## Swoft Package Manager / CocoaPods

Se probó SPM, sin embargo dio problemas, posiblemente porque se usó la última versión de Xcode para el proyecto. En su lugar se usó CocoaPods (el repo oficial usa CocoaPods). Con Xcode recientes puede aparecer el error rsync Operation not permitted; workaround descubierto: desactivar User Script Sandboxing en Build Settings o ajustar permisos. Se desactivó "User Script Sandboxing" (de YES a NO) en Xcode -> Target -> Build Setting.

# 4. Aspectos que se podrían mejorar o extender

Router / Coordinator para navegación y presentaciones (medio plazo). Aunque solo se recomienda si se quiere que el imagePicker se quite del FaceViewController y se pase al FacePresenter, aunque tal y como está, para lo que se necesita, es la opción más óptima.

Extraer la presentación del ImagePicker y del módulo de captura a un Router desacoplaría aún más el Presenter de UIKit y facilitaría testing y reutilización en pantallas múltiples.

## Distinción entre captura SDK vs foto rápida de cámara

Actualmente la captura recomendada viene del SDK (liveness). Si se mantiene la opción de cámara del ImagePicker, definir claramente si esa foto cuenta como “captured” o “gallery” podría haber una posible confusión en la calidad o comparación. Se decidió implementar la toma de fotografía con liveness ya que así se implementa en el código de ejemplo y la falta de tiempo para profundizar en otras alternativas, no permitieron explorar otros métodos.

## Mejoras en UI/UX

Mostrar un HUD con progreso durante matchFaces.

## Tests unitarios y mocks

Añadir tests al Presenter usando un mock FaceSDKServiceProtocol. Verificar comportamiento con success/failure y estados de carga/errors.

Además de hacer UI tests para flujo de selección/captura/comparación.

## Internacionalización y accesibilidad

Pasar strings a Localizable.strings y añadir etiquetas/accessibility identifiers para testing y usuarios con VoiceOver.
