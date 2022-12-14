using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

public class HapticController : MonoBehaviour
{
    // Haptic controller with a series of overloaded functions for different ways of vibrating the respective controllers
    public XRBaseController defaultLeftController, defaultRightController;
    public static XRBaseController leftController, rightController;

    public float defaultAmplitude = 0.2f;
    public float defaultDuration = 0.5f;

    [ContextMenu("SendHaptics")]
    public void SendHaptics() // Pulse both controllers with standard values
    {
        defaultLeftController.SendHapticImpulse(defaultAmplitude, defaultDuration);
        defaultRightController.SendHapticImpulse(defaultAmplitude, defaultDuration);
    }

    public static void SendHaptics(float amplitude, float duration) // Pulse both controllers with defined values [OVERLOAD1]
    {
        leftController.SendHapticImpulse(amplitude, duration);
        rightController.SendHapticImpulse(amplitude, duration);
    }

    public static void SendHaptics(bool isLeftController, float amplitude, float duration) // Pulse left or right controller with defined values [OVERLOAD2]
    {
        if (isLeftController)
        {
            leftController.SendHapticImpulse(amplitude, duration);
        }
        else
        {
            rightController.SendHapticImpulse(amplitude, duration);
        }
    }

    public static void SendHaptics(XRBaseController controller, float amplitude, float duration) // Pulse a defined controller with defined values [OVERLOAD3]
    {
        controller.SendHapticImpulse(amplitude, duration);
    }
}
    

/* Example use of haptic controller functions 
class NewClass
{
    public void Shoot()
    {
        HapticController.SendHaptics(.1f, .7f);
    }
}
*/