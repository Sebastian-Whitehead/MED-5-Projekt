using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

[RequireComponent(typeof(ActionBasedController))]
public class HandController : MonoBehaviour
{
    private ActionBasedController _controller; // VR controller
    public Hand hand;   // hand component from hand game-object

    private void Start()
    {
        _controller = GetComponent<ActionBasedController>(); // Get controller component
    }

    // Update is called once per frame
    private void Update()
    {
        // read controller and update hand model to match
        hand.SetGrip(_controller.selectAction.action.ReadValue<float>()); 
        hand.SetTrigger(_controller.activateAction.action.ReadValue<float>()); 
    }
}
