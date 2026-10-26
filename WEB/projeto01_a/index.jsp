export class Game {
    constructor() {
        this.state = 'MENU'; // MENU, CLASS_SELECT, PLAYING, PAUSED
        this.container = document.getElementById('canvas-container');
        this.selectedTeam = null;
        this.selectedClass = null;
        
        // Dados do jogador
        this.playerHP = 100;
        this.maxHP = 100;
        this.ammo = 20;
        this.maxAmmo = 20;

        this.initUI();
    }

    init() {
        // Configuração do Three.js
        this.scene = new THREE.Scene();
        this.scene.background = new THREE.Color(0x87ceeb); // Céu estilizado

        this.camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
        this.camera.position.set(0, 2, 5);

        this.renderer = new THREE.WebGLRenderer({ antialias: true });
        this.renderer.setSize(window.innerWidth, window.innerHeight);
        this.container.appendChild(this.renderer.domElement);

        // Iluminação
        const ambientLight = new THREE.AmbientLight(0xffffff, 0.6);
        this.scene.add(ambientLight);

        const dirLight = new THREE.DirectionalLight(0xffffff, 0.8);
        dirLight.position.set(10, 20, 10);
        this.scene.add(dirLight);

        // Criar Arena Provisória (Mapa industrial simples)
        this.createArena();

        // Listeners de Janela
        window.addEventListener('resize', () => this.onWindowResize());

        // Iniciar Loop
        this.clock = new THREE.Clock();
        this.animate();
    }

    initUI() {
        document.getElementById('btn-play').addEventListener('click', () => {
            document.getElementById('main-menu').classList.add('hidden');
            document.getElementById('class-select-screen').classList.remove('hidden');
        });

        // Seleção de Equipe
        document.querySelectorAll('.team-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                document.querySelectorAll('.team-btn').forEach(b => b.classList.remove('selected'));
                e.target.classList.add('selected');
                this.selectedTeam = e.target.getAttribute('data-team');
                this.checkReadyToStart();
            });
        });

        // Seleção de Classe
        document.querySelectorAll('.class-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                document.querySelectorAll('.class-btn').forEach(b => b.classList.remove('selected'));
                e.target.classList.add('selected');
                this.selectedClass = e.target.getAttribute('data-class');
                this.checkReadyToStart();
            });
        });

        // Entrar na Arena
        document.getElementById('btn-start-match').addEventListener('click', () => {
            document.getElementById('class-select-screen').classList.add('hidden');
            document.getElementById('hud').classList.remove('hidden');
            this.state = 'PLAYING';
            
            // Solicitar Pointer Lock para visão em primeira pessoa
            document.body.requestPointerLock();
        });
    }

    checkReadyToStart() {
        if (this.selectedTeam && this.selectedClass) {
            document.getElementById('btn-start-match').removeAttribute('disabled');
        }
    }

    createArena() {
        // Chão
        const floorGeo = new THREE.PlaneGeometry(100, 100);
        const floorMat = new THREE.MeshStandardMaterial({ color: 0x555555, roughness: 0.8 });
        const floor = new THREE.Mesh(floorGeo, floorMat);
        floor.rotation.x = -Math.PI / 2;
        this.scene.add(floor);

        // Paredes e obstáculos da base
        const wallMat = new THREE.MeshStandardMaterial({ color: 0x8b4513 });
        
        const boxGeo = new THREE.BoxGeometry(5, 5, 5);
        const box = new THREE.Mesh(boxGeo, wallMat);
        box.position.set(10, 2.5, -10);
        this.scene.add(box);

        const box2 = new THREE.Mesh(boxGeo, wallMat);
        box2.position.set(-10, 2.5, -10);
        this.scene.add(box2);
    }

    onWindowResize() {
        this.camera.aspect = window.innerWidth / window.innerHeight;
        this.camera.updateProjectionMatrix();
        this.renderer.setSize(window.innerWidth, window.innerHeight);
    }

    animate() {
        requestAnimationFrame(() => this.animate());

        const deltaTime = this.clock.getDelta();

        if (this.state === 'PLAYING') {
            // Lógica de atualização de jogo e IA local virá aqui
        }

        this.renderer.render(this.scene, this.camera);
    }
}