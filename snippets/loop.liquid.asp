<script>
    // Product customizer
    const LOADER = document.getElementById('js-loader');
    const BACKGROUND_COLOR = 0xffffff;
    const INITIAL_MTL = new THREE.MeshPhongMaterial({ color: 0xffffff, shininess: 10 });
    var loaded = false;
    var cameraFar = 7;
    var i = 0;
    var floorGeometry = new THREE.PlaneGeometry(5000, 5000, 1, 1);
    var floorMaterial = new THREE.MeshPhongMaterial({
        color: 0xffffff,
        shininess: 0 
    });

    function createCanvases(){
        var canvases = [];
        var MODEL_PATH = [];
        var theModel = [];
        var activeOption = [];
        var scene = [];
        var canvas = [];
        var renderer = [];
        var camera = [];
        var loader = [];
        var hemiLight = [];
        var dirLight = [];
        var floor = [];
        var controls = [];

        for (const element of document.querySelectorAll('.customized-product')) {
            var modelPath = element.getAttribute('data-model-path');
            var activeMap = element.getAttribute('data-active-path');
            var canvasClass = element.id;
            var parentClass = element.getAttribute('data-parent');    
            i++;

            activeOption[i] = activeMap;
            scene[i] = new THREE.Scene();
            scene[i].background = new THREE.Color(BACKGROUND_COLOR);
            scene[i].fog = new THREE.Fog(BACKGROUND_COLOR, 20, 100);

            canvas[i] = canvasClass;
            renderer[i] = new THREE.WebGLRenderer({ canvasClass, antialias: true });
            renderer[i].shadowMap.enabled = true;
            renderer[i].setPixelRatio(window.devicePixelRatio);

            document.getElementById(parentClass).appendChild(renderer[i].domElement);

            camera[i] = new THREE.PerspectiveCamera(50, window.innerWidth / window.innerHeight, 0.1, 1000);
            camera[i].position.z = cameraFar;
            camera[i].position.x = 0;

            loader[i] = new THREE.GLTFLoader();
            loader[i].load(modelPath, function (gltf) {
                theModel[i] = gltf.scene;
                theModel[i].traverse(o => {
                    if (o.isMesh) {
                        o.castShadow = true;
                        o.receiveShadow = true;
                    }
                });

                theModel[i].scale.set(2, 2, 2);
                theModel[i].rotation.y = Math.PI;
                theModel[i].position.y = -1;

                theModel[i].traverse(o => {
                    if (o.isMesh) {
                        if (o.name.includes(activeMap)) {
                            o.material = INITIAL_MTL;
                            o.nameID = activeMap;
                        }
                    }
                });

                // Add the model to the scene
                scene[i].add(theModel[i]);
            });

            // Add lights
            hemiLight[i] = new THREE.HemisphereLight(0xffffff, 0xffffff, 0.61);
            hemiLight[i].position.set(0, 50, 0);
            scene[i].add(hemiLight[i]);

            dirLight[i] = new THREE.DirectionalLight(0xffffff, 0.54);
            dirLight[i].position.set(-8, 12, 8);
            dirLight[i].castShadow = true;
            dirLight[i].shadow.mapSize = new THREE.Vector2(1024, 1024);  
            scene[i].add(dirLight[i]);   

            floor[i] = new THREE.Mesh(floorGeometry, floorMaterial);
            floor[i].rotation.x = -0.5 * Math.PI;
            floor[i].receiveShadow = true;
            floor[i].position.y = -1;
            scene[i].add(floor[i]);

            // Remove the loader
            LOADER.remove();
        }

        //return canvases, MODEL_PATH, theModel,activeOption, scene, canvas, renderer, camera, loader, hemiLight, dirLight, floor;
    }

    createCanvases();
</script>