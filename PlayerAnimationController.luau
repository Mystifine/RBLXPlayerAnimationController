local ReplicatedStorage = game.ReplicatedStorage;
local Players = game.Players;

local player = Players.LocalPlayer;

local MysLib = require(ReplicatedStorage.Dependencies.MysLib);

local AnimationService = require(ReplicatedStorage.Services.AnimationService);

local PlayerAnimationController = {}

local characterAnimations = {
	IdleAnim = ReplicatedStorage.Animations.Player.IdleAnim;
	FallAnim = ReplicatedStorage.Animations.Player.FallAnim;
	JumpAnim = ReplicatedStorage.Animations.Player.JumpAnim;
	WalkAnim = ReplicatedStorage.Animations.Player.WalkAnim;
}

local POSE_ENUMS = {
	Idle = "Idle";
	Jump = "Jump";
	Fall = "Fall";
	Walk = "Walk";
}

local currentPose = POSE_ENUMS.Idle;
local jumpAnimTime = 0
local jumpAnimDuration = 0.3 -- Default Roblox duration
local fallTransitionTime = 0.3 

function PlayerAnimationController.update(deltaTime)
	local character = player.Character
	if not MysLib.PlayerUtil.isCharacterAlive(character) then return end

	local humanoid = character.Humanoid
	local animator = humanoid.Animator
	local humanoidRootPart = character.HumanoidRootPart

	if jumpAnimTime > 0 then
		jumpAnimTime = jumpAnimTime - deltaTime
	end

	local velocity = humanoidRootPart.AssemblyLinearVelocity
	local verticalVelocity = velocity.Y
	local horizontalVelocity = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
	local isAirBorne = humanoid.FloorMaterial == Enum.Material.Air

	local newPose = currentPose 
	
	if humanoid:GetState() == Enum.HumanoidStateType.Jumping or (verticalVelocity > 20 and jumpAnimTime > 0) then
		newPose = POSE_ENUMS.Jump
	elseif verticalVelocity < 0 then
		newPose = POSE_ENUMS.Fall
	else
		-- Ground States
		if horizontalVelocity > 0.5 and not isAirBorne then
			newPose = POSE_ENUMS.Walk
		elseif not isAirBorne then
			newPose = POSE_ENUMS.Idle
		end
	end

	if currentPose ~= newPose then
		local oldAnim = characterAnimations[currentPose .. "Anim"]
		if oldAnim then
			AnimationService.stopAnimation(animator, oldAnim, 0.1)
		end

		local transition = (newPose == POSE_ENUMS.Fall) and fallTransitionTime or 0.1
		local newAnim = characterAnimations[newPose .. "Anim"]

		if newAnim then
			AnimationService.playAnimation(animator, newAnim, transition)
		end

		if newPose == POSE_ENUMS.Jump then
			jumpAnimTime = jumpAnimDuration
		end

		currentPose = newPose
	end

	if currentPose == POSE_ENUMS.Walk then
		local walkTrack = AnimationService.getAnimation(animator, characterAnimations.WalkAnim)
		walkTrack:AdjustSpeed(horizontalVelocity / 16)
	end
end

function PlayerAnimationController._onCharacterAdded(character : Model)
	local humanoid = character:WaitForChild("Humanoid");
	local animator = humanoid:WaitForChild("Animator");
	
	-- Play idle animation
	AnimationService.playAnimation(animator, characterAnimations.IdleAnim);
end

function PlayerAnimationController.main()
	
	local character = player.Character or player.CharacterAdded:Wait();
	task.spawn(PlayerAnimationController._onCharacterAdded, character);
	player.CharacterAdded:Connect(PlayerAnimationController._onCharacterAdded);
	
	MysLib.GeneralUtil.Heartbeat.new(PlayerAnimationController.update);
	
end

return PlayerAnimationController
