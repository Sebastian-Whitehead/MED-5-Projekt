using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Animator))]        //Code cannot run without field being filled
public class Hand : MonoBehaviour
{
    Animator animator;
    SkinnedMeshRenderer mesh;
    private float gripTarget;       // Recieved grip float from controller "handcontroller.cs"
    private float triggerTarget;    // Recieved trigger float from controller "handcontroller.cs"
    private float gripCurrent;      // Current grip float of model
    private float triggerCurrent;   // Current trigger float of model 
    public float speed;             // Animation Interpolation Speed
    private string animatorGripParam = "Grip";          // Animator Varriable Name
    private string animatorTriggerParam = "Trigger";    // Animator Varriable Name

    void Start()
    {
        animator = GetComponent<Animator>();
        mesh = GetComponentInChildren<SkinnedMeshRenderer>();
    }

    // Update is called once per frame
    void Update()
    {
        AnimateHand();    
    }

    internal void SetGrip(float v)      // Recieve Grip Float 
    {
        gripTarget = v;
    }

    internal void SetTrigger(float v)   // Recieve Trigger Float
    {
        triggerTarget = v;
    }

    void AnimateHand()
    {
        if (gripCurrent != gripTarget)
        {
            //interpolates between current model positon and recieved controller position at a given speed
            gripCurrent = Mathf.MoveTowards(gripCurrent, gripTarget, Time.deltaTime * speed);  
            animator.SetFloat(animatorGripParam, gripCurrent);      //set parameter inside animator
        }
        if (triggerCurrent != triggerTarget)
        {
            triggerCurrent = Mathf.MoveTowards(triggerCurrent, triggerTarget, Time.deltaTime * speed);
            animator.SetFloat(animatorTriggerParam, triggerCurrent);    //set paramater inside animtor
        }

    }

    public void ToggleVisibility()
    {
        mesh.enabled = !mesh.enabled;
    }
}
