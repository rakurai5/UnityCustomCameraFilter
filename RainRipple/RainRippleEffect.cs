using UnityEngine;

[ExecuteInEditMode]
public class RainRippleEffect : CustomImageEffectBase
{
    #region Fields
    [SerializeField]
    private float RippleScale = 15.0f;
    [SerializeField]
    [Range(0.0f, 1.0f)]
    private float RainNormal = 0.15f;
    [SerializeField]
    private float RainSpeed = 0.15f;

    #endregion

    #region Properties

    public override string ShaderName
    {
        get { return "CustomFilter/RainRipple"; }
    }

    #endregion

    #region Methods

    protected override void UpdateMaterial()
    {

        Material.SetFloat("_RippleScale", RippleScale);
        Material.SetFloat("_RainNormal", RainNormal);
        Material.SetFloat("_RainSpeed", RainSpeed);
       

    }

    #endregion

}
