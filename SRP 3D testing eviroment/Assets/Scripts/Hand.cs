using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Animator))]        //Code cannot run without field being filled
public class Hand : MonoBehaviour
{
    private Animator _animator;     //animation controller on same hand model
    private SkinnedMeshRenderer _mesh;
    
    private float _gripTarget;       // Received grip float from controller "HandController.cs"
    private float _triggerTarget;    // Received trigger float from controller "HandController.cs"
    
    private float _gripCurrent;      // Current grip float of model
    private float _triggerCurrent;   // Current trigger float of model 
    public float speed;              // Animation Interpolation Speed
    private static readonly int Grip = Animator.StringToHash(AnimatorGripParam);
    private static readonly int Trigger = Animator.StringToHash(AnimatorTriggerParam);

    private const string AnimatorGripParam = "Grip"; // Animator Variable Name
    private const string AnimatorTriggerParam = "Trigger";    // Animator Variable Name

    private void Start()
    {
        _animator = GetComponent<Animator>();
        _mesh = GetComponentInChildren<SkinnedMeshRenderer>();
    }

    // Update is called once per frame
    void Update()
    {
        AnimateHand();    
    }

    internal void SetGrip(float v)      // Receive Grip Float 
    {
        _gripTarget = v;
    }

    internal void SetTrigger(float v)   // Receive Trigger Float
    {
        _triggerTarget = v;
    }

    void AnimateHand()
    {
        if (_gripCurrent != _gripTarget)
        {
            //interpolates between current model position and received controller position at a given speed
            _gripCurrent = Mathf.MoveTowards(_gripCurrent, _gripTarget, Time.deltaTime * speed);  
            _animator.SetFloat(Grip, _gripCurrent);      //set parameter inside animator
        }
        if (_triggerCurrent != _triggerTarget)
        {
            _triggerCurrent = Mathf.MoveTowards(_triggerCurrent, _triggerTarget, Time.deltaTime * speed);
            _animator.SetFloat(Trigger, _triggerCurrent);    //set parameter inside animator
        }

    }

    public void ToggleVisibility()
    {
        _mesh.enabled = !_mesh.enabled;
    }
}
